import UIKit
import Locksmith

class SearchItemController: UIViewController {
    
    var productData: [CategoryProduct]? //Get item from home
    var categoryData: [CategoryProduct] = [] //Filter items by group
    var orderItems: [OrderModel] = [] //Store items
    
    //Create SearchParam.
    var searchGroup: GroupModel?
    var searchLocation: LocationModel?
    var searchDate: DateModel?
    
    @IBOutlet weak var productTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareCategoryData()
        self.productTable.register(UINib(nibName: "ProductItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        self.productTable.dataSource = self
    }
    
    @IBAction func gotoSummary(_ sender: UIButton) {
        let loadedData = Locksmith.loadDataForUserAccount(userAccount: "admin")!
        if Bool((loadedData["isLogin"] as? Int)!) {
            print("It's true")
            do {
                try Locksmith.updateData(data: ["isLogin": false], forUserAccount: "admin")
            } catch {
                print(error)
            }
        } else {
            do {
                try Locksmith.updateData(data: ["isLogin": true], forUserAccount: "admin")
            } catch {
                print(error)
            }
            print("It's not true")
        }
        
    }
    
    @IBAction func backToHome(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func prepareCategoryData() {
        for items in self.productData! {
            if items.groupId == self.searchGroup?.groupId {
                self.categoryData.append(items)
            } else {
                print("Not match")
            }
        }
    }
}

extension SearchItemController: ProductItemCellDelegate {
    func didChageAmount(product: ProductModel, itemLabel: String, itemAmount: Double) {
        let totalPrice = product.productRentPrice * itemAmount
        if self.orderItems.count == 0 {
            let order = OrderModel(id: product.id,
                                   productCategory: product.productCategory,
                                   productGroup: product.productGroup, productId: product.productId,
                                   productSize: product.productSize,
                                   productRentPrice: product.productRentPrice,
                                   productRent: Int(itemAmount),
                                   productQuantity: product.productQuantity,
                                   productBalance: Int(itemAmount),
                                   totalForItem: String(totalPrice))
            self.orderItems.append(order)
        } else {
            if itemAmount == 0.0 {
                for i in 0..<self.orderItems.count {
                    if product.id == self.orderItems[i].id {
                        self.orderItems.remove(at: i)
                        break
                    }
                }
            } else {
                var searchCheck = false
                for i in 0..<self.orderItems.count {
                    if product.id == self.orderItems[i].id {
                        self.orderItems[i].productRent = Int(itemAmount)
                        self.orderItems[i].productBalance = Int(itemAmount)
                        self.orderItems[i].totalForItem = String(totalPrice)
                        searchCheck = true
                        break
                    }
                }
                if !searchCheck {
                    let order = OrderModel(id: product.id,
                                           productCategory: product.productCategory,
                                           productGroup: product.productGroup,
                                           productId: product.productId,
                                           productSize: product.productSize,
                                           productRentPrice: product.productRentPrice,
                                           productRent: Int(itemAmount),
                                           productQuantity: product.productQuantity,
                                           productBalance: Int(itemAmount),
                                           totalForItem: String(totalPrice))
                    self.orderItems.append(order)
                }
            }
        }
        print(self.orderItems)
    }
}

extension SearchItemController: UITableViewDataSource {
    
    private func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.text = "    \(self.categoryData[section].categoryName)"
        header.backgroundColor = UIColor(rgb: ColorString.BlackGrey)
        header.textColor = UIColor(rgb: ColorString.White)
        return header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.categoryData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryData[section].productItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.productTable.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ProductItemCell
        cell.delegate = self
        cell.productInfo = self.categoryData[indexPath.section].productItem[indexPath.row]
        cell.itemLabel.text = " \(self.categoryData[indexPath.section].productItem[indexPath.row].productId)  ขนาด: \(self.categoryData[indexPath.section].productItem[indexPath.row].productSize)"
        cell.noteLabel.text = " ราคาเช่า (บาท/วัน):  \(self.categoryData[indexPath.section].productItem[indexPath.row].productRentPrice)"
        return cell
    }
}
