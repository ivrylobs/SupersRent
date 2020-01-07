import UIKit
import Locksmith
import SwiftyJSON

class ItemSelectController: UIViewController {
    
    var productData: [CategoryProduct]? //Get item from home
    var categoryData: [CategoryProduct] = [] //Filter items by group
    static var orderItems: [OrderModel] = [] //Store items
    
    
    //Create SearchParam.
    var searchGroup: GroupModel?
    var searchLocation: LocationModel?
    var searchDate: DateModel?
    
    @IBOutlet weak var productTable: UITableView!
	@IBOutlet weak var totalPrice: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Prepare Items Data.
        self.prepareCategoryData()
		ItemSelectController.orderItems = []
        
        //Register Custom Cell.
		let cellNib = UINib(nibName: "ProductItemCell", bundle: nil)
        self.productTable.register(cellNib, forCellReuseIdentifier: "ItemCell")
        
        //Make DataSource and Protocal Delegate
        self.productTable.dataSource = self
		self.productTable.delegate = self
        self.productTable.allowsSelection = false
        
        self.productTable.tableFooterView = UIView()
		
		let currencyFormatter = NumberFormatter()
		currencyFormatter.usesGroupingSeparator = true
		currencyFormatter.numberStyle = .currency
		
		// localize to your grouping and decimal separator
		currencyFormatter.locale = Locale(identifier: "th_TH")
		
		self.totalPrice.text = currencyFormatter.string(from: NSNumber(value: 0.00))!
        
    }
    
    @IBAction func gotoSummary(_ sender: UIButton) {
		
		var priceSummary = 0.0
		for item in ItemSelectController.orderItems {
			priceSummary += Double(item.totalForItem)!
		}
		
		if priceSummary < 20.0 {
			self.showAlertForMinimiumPrice()
		} else {
			if ItemSelectController.self.orderItems.count == 0 {
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
    }
	
	@IBAction func backToHome(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == NameConstant.SegueID.itemToSummayID {
            let destinationVC = segue.destination as? OrderSummayController
			destinationVC?.orderItems = ItemSelectController.self.orderItems
            destinationVC?.orderDates = self.searchDate
            destinationVC?.orderLocation = self.searchLocation
        }
    }
    
    func prepareCategoryData() {
        for items in self.productData! {
            if items.groupId == self.searchGroup?.groupId {
                self.categoryData.append(items)
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
	
	func showAlertForMinimiumPrice() {
		// create the alert
		let alert = UIAlertController(title: "ผิดพลาด", message: "ยอดขั้น 20 บาท, กรุณาเลือกสินค้าเพิ่ม", preferredStyle: UIAlertController.Style.alert)
		
		// add an action (button)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
		
		// show the alert
		self.present(alert, animated: true, completion: nil)
	}
}

extension ItemSelectController: UITableViewDelegate {
	
}

extension ItemSelectController: ItemCellControllerDelegate {
	func didChageAmount(tableCellItem: ItemCell, product: ProductModel, inputType: String) {
		
		var isItemInList = false
		
		for i in 0..<ItemSelectController.orderItems.count {
			if tableCellItem.productInfo?.id == ItemSelectController.orderItems[i].id {
				isItemInList = true
				
				if inputType == "increase" {
					ItemSelectController.orderItems[i].changeAmount(itemAmount: ItemSelectController.orderItems[i].productRent + 1)
					tableCellItem.changeAmountLabel(amount: ItemSelectController.orderItems[i].productRent, product: product)
				} else {
					if ItemSelectController.orderItems[i].productRent > 1 {
						ItemSelectController.orderItems[i].changeAmount(itemAmount: ItemSelectController.orderItems[i].productRent - 1)
						tableCellItem.changeAmountLabel(amount: ItemSelectController.orderItems[i].productRent, product: product)
					} else {
						ItemSelectController.orderItems.remove(at: i)
						tableCellItem.changeAmountLabel(amount: 0,product: product)
					}
				}
			}
		}
		
		if !isItemInList {
			if inputType == "increase" {
				let order = OrderModel(id: product.id,
									   productCategory: product.productCategory,
									   productGroup: product.productGroup,
									   productId: product.productId,
									   productSize: product.productSize,
									   productRentPrice: product.productRentPrice,
									   productRent: 1,
									   productQuantity: product.productQuantity,
									   productBalance: 1,
									   totalForItem: String(format: "%.2f", product.productRentPrice * 1))
				ItemSelectController.orderItems.append(order)
				tableCellItem.changeAmountLabel(amount: 1, product: product)
			}
		}
		

		print(ItemSelectController.orderItems.count)
		print(product.id, product.productId)
		print(ItemSelectController.orderItems)
		
		let currencyFormatter = NumberFormatter()
		
		currencyFormatter.usesGroupingSeparator = true
		currencyFormatter.numberStyle = .currency
		
		// localize to your grouping and decimal separator
		currencyFormatter.locale = Locale(identifier: "th_TH")

		var priceSummary = 0.0
		for item in ItemSelectController.self.orderItems {
			priceSummary += Double(item.totalForItem)!
		}

		self.totalPrice.text = currencyFormatter.string(from: NSNumber(value: priceSummary))!
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
		
		for item in ItemSelectController.orderItems {
			if item.productId == cell.productInfo?.productId {
				print("Have in list")
				cell.quantityLabel.text = "\(item.productRent)"
				print(cell.productInfo?.productId, item.productRent)
				break
			} else {
				cell.quantityLabel.text = "0"
			}
		}
		
		print("Confirm value: \(cell.quantityLabel.text)")
        return cell
    }
}
