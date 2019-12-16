import UIKit
import Locksmith
import SwiftyJSON

class ItemSelectController: UIViewController {
    
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
        
        //Prepare Items Data.
        self.prepareCategoryData()
        
        //Register Custom Cell.
        self.productTable.register(UINib(nibName: "ProductItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        
        //Make DataSource and Protocal Delegate
        self.productTable.dataSource = self
        self.productTable.delegate = self
        self.productTable.allowsSelection = false
        
        self.productTable.tableFooterView = UIView()
        
    }
    
    @IBAction func gotoSummary(_ sender: UIButton) {
        
        if self.orderItems.count == 0 {
            showAlertFill()
        } else {
            let loadedData = Locksmith.loadDataForUserAccount(userAccount: "admin")!
            let userData = JSON(loadedData)
            if userData["isLogin"].boolValue {
                self.performSegue(withIdentifier: NameConstant.SegueID.itemToSummayID, sender: self)
            } else {
                self.performSegue(withIdentifier: NameConstant.SegueID.itemToLoginID, sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == NameConstant.SegueID.itemToSummayID {
            let destinationVC = segue.destination as? OrderSummayController
            destinationVC?.orderItems = self.orderItems
            destinationVC?.orderDates = self.searchDate
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
                print("Not Match")
            }
        }
    }
    
    func showAlertFill() {
        // create the alert
        let alert = UIAlertController(title: "ผิดพลาด", message: "กรุณาเลือกสินค้า", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}

extension ItemSelectController: ItemCellControllerDelegate {
    func didChageAmount(product: ProductModel, itemAmount: Double) {
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
        //print(self.orderItems.count)
    }
}

extension ItemSelectController: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.categoryData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryData[section].productItem.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Create Section Header
        let header = UILabel()
        
        //Set Header properties.
        header.text = "  \(self.categoryData[section].categoryName)"
        header.backgroundColor = UIColor(rgb: 0x222831)
        header.textColor = UIColor(rgb: ColorString.White)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //Create UITableViewCell.
        let cell = self.productTable.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        //Make Cell Delegate to this Controller
        cell.delegate = self
        
        //Make Cell
        cell.productInfo = self.categoryData[indexPath.section].productItem[indexPath.row]
        
        //Setup Cell Component
        let category = self.categoryData[indexPath.section].productItem[indexPath.row].productId
        let size = self.categoryData[indexPath.section].productItem[indexPath.row].productSize
        let price = self.categoryData[indexPath.section].productItem[indexPath.row].productRentPrice
        cell.itemLabel.text = " รหัส: \(category)"
        cell.sizeLabel.text = " ขนาด: \(size)"
        cell.priceLabel.text = " ราคาเช่า(บาท/วัน):  \(price)"
        
        //print("\(indexPath.section): \(indexPath.row)")
        return cell
    }
}

extension ItemSelectController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.productTable.deselectRow(at: indexPath, animated: false)
        //print("here")
    }
}
