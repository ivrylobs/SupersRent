import UIKit
import Locksmith
import SwiftyJSON
import Alamofire

class OrderSummayController: UIViewController {
    
    var orderItems: [OrderModel]?
    var orderDates: DateModel?
    var orderLocation: LocationModel?
    
    var orderID: String?
    
    @IBOutlet weak var itemSummaryTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register Custom Cell
        self.itemSummaryTable.register(UINib(nibName: "SummaryItemCell", bundle: nil), forCellReuseIdentifier: "SummaryItemCell")
        self.itemSummaryTable.register(UINib(nibName: "PriceSummaryCell", bundle: nil), forCellReuseIdentifier: "PriceSummaryCell")
        self.itemSummaryTable.register(UINib(nibName: "UserInfoCell", bundle: nil), forCellReuseIdentifier: "UserInfoCell")
        self.itemSummaryTable.register(UINib(nibName: "RentTimeCell", bundle: nil), forCellReuseIdentifier: "RentTimeCell")
        self.itemSummaryTable.register(UINib(nibName: "SummaryCell", bundle: nil), forCellReuseIdentifier: "SummaryCell")
        
        //Make DataSource and Protocal Delegate
        self.itemSummaryTable.dataSource = self
        self.itemSummaryTable.delegate = self
        
        self.itemSummaryTable.tableFooterView = UIView()
    }
    
    @IBAction func orderCheckOut(_ sender: UIButton) {
        var itemCount = 0
        var totalPrice = 0.0
        
        let diffInDays = Calendar.current.dateComponents([.day], from: self.orderDates!.firstDate, to: self.orderDates!.finalDate).day
        
        for data in self.orderItems! {
            itemCount += data.productRent
            totalPrice += Double(data.totalForItem)!
        }
        
        let loadedData = JSON(Locksmith.loadDataForUserAccount(userAccount: "admin")!)
        let userData = loadedData["userData"].dictionaryValue
        let urlOrder = "https://api.supersrent.com/app-user/api/order/addCustomerOrderDetail/"
        let header = ["Accept":"application/json","AuthorizationHome": loadedData["tokenAccess"].stringValue]
        
        let orderCustomer: [String : Any] = [
            "firstName": userData["firstName"]!.stringValue,
            "lastName": userData["lastName"]!.stringValue,
            "phone": userData["phone"]!.stringValue,
            "email": userData["email"]!.stringValue,
            "roles": []
            ]
        var orderItems: [[String : Any]] = []
        
        for item in self.orderItems! {
            let itemAppend: [String : Any] = [
                "id": item.id,
                "category": item.productCategory,
                "group": item.productGroup,
                "productId": item.productId,
                "productSize": item.productSize,
                "productRentPrice": item.productRentPrice,
                "productRent": item.productRent,
                "productQuantity": item.productQuantity,
                "productBalance": item.productBalance,
                "totalForItem": item.totalForItem
                ]
            orderItems.append(itemAppend)
        }
        let postOrder: [String : Any] = [
            "orderAllItemBalance": itemCount,
            "orderAllTotalAndVAT": totalPrice * Double(diffInDays!) + totalPrice * Double(diffInDays!) * 0.07,
            "orderContractEndFormat": self.orderDates!.finalDate.description(with: Locale(identifier: "th_TH")),
            "orderContractStart": self.orderDates!.firstDate.description,
            "orderContractStartFormat": self.orderDates!.firstDate.description(with: Locale(identifier: "th_TH")),
            "orderCustomer": orderCustomer,
            "orderDate": Date().description,
            "orderItemAllTotal": totalPrice * Double(diffInDays!),
            "orderItemTotal": totalPrice,
            "orderItems": orderItems,
            "orderLocationDistrict": self.orderLocation!.districtName,
            "orderLocationProvince": self.orderLocation!.provinceName,
            "orderNumberOfItem": itemCount,
            "orderNumberOfItemOrder": self.orderItems!.count,
            "orderStatus": false,
            "orderTimeRent": diffInDays!,
            "orderVAT": totalPrice * Double(diffInDays!) * 0.07
        ]
        print(postOrder)
        Alamofire.request(urlOrder, method: .post, parameters: postOrder, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                let jsonData = JSON(data)
                print(jsonData)
                self.orderID = jsonData["orderId"].stringValue
                self.performSegue(withIdentifier: NameConstant.SegueID.summaryToPaymentID, sender: self)
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var itemCount = 0
        var totalPrice = 0.0
        
        let diffInDays = Calendar.current.dateComponents([.day], from: self.orderDates!.firstDate, to: self.orderDates!.finalDate).day
        
        for data in self.orderItems! {
            itemCount += data.productRent
            totalPrice += Double(data.totalForItem)!
        }
        let payPrice = totalPrice * Double(diffInDays!) + totalPrice * Double(diffInDays!) * 0.07
        let destinationVC = segue.destination as! OrderPaymentController
		
        destinationVC.orderID = self.orderID!
		destinationVC.rentPricePerDay = totalPrice
		destinationVC.priceDurationRent = totalPrice * Double(diffInDays!)
		destinationVC.dayRent = diffInDays
        destinationVC.payPrice = payPrice
    }
    
    @IBAction func backToViewController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension OrderSummayController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var header = ""
        
        if section == 0 {
            header = "ข้อมูลติดต่อ"
        } else if section == 1 {
            header = "สรุปรายการสินค้า"
        } else if section == 2 {
            header = "รายละเอียดการเช่า"
        } else {
            header = "สรุป"
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var size:CGFloat?
        
        if indexPath.section == 0 {
            size = CGFloat(250)
        } else if indexPath.section == 1 {
            size = CGFloat(90)
        } else if indexPath.section == 2 {
            size = CGFloat(200)
        } else {
            size = CGFloat(220)
        }
        return size!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var row:Int?
        
        if section == 0 {
            row = 1
        } else if section == 1 {
            row = self.orderItems!.count + 1
        } else if section == 2 {
            row = 1
        } else {
            row = 1
        }
        
        return row!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if indexPath.section == 0 {
            
            let loadedData = Locksmith.loadDataForUserAccount(userAccount: "admin")
            let jsonData = JSON(loadedData!)
            let userData = jsonData["userData"]
            
            //print(userData)
            
            let infoCell = self.itemSummaryTable.dequeueReusableCell(withIdentifier: "UserInfoCell", for: indexPath) as! UserInfoCell
            infoCell.firstName.text = userData["firstName"].stringValue
            infoCell.sirName.text = userData["lastName"].stringValue
            infoCell.phoneNumber.text = userData["phone"].stringValue
            infoCell.userEmail.text = userData["email"].stringValue
            
            cell = infoCell
        } else if indexPath.section == 1 {
            if indexPath.row == self.orderItems!.count {
                
                var itemCount = 0
                var totalPrice = 0.0
                
                for data in self.orderItems! {
                    itemCount += data.productRent
                    totalPrice += Double(data.totalForItem)!
                }
                let priceCell = self.itemSummaryTable.dequeueReusableCell(withIdentifier: "PriceSummaryCell", for: indexPath) as! PriceSummaryCell
                let amount = String(itemCount)
                let summaryPrice = String(format: "%.2f", totalPrice)
                priceCell.amountLabel.text = amount
                priceCell.summaryPriceLabel.text = summaryPrice
                
                cell = priceCell
            } else {
                let summaryCell = self.itemSummaryTable.dequeueReusableCell(withIdentifier: "SummaryItemCell", for: indexPath) as! SummaryItemCell
                summaryCell.categoryLabel.text = self.orderItems![indexPath.row].productCategory
                summaryCell.itemIdLabel.text = self.orderItems![indexPath.row].productId
                summaryCell.itemSizeLabel.text = self.orderItems![indexPath.row].productSize
                summaryCell.itemPriceLabel.text = String(self.orderItems![indexPath.row].productRentPrice)
                summaryCell.itemAmount.text = String(self.orderItems![indexPath.row].productRent)
                summaryCell.itemTotal.text = self.orderItems![indexPath.row].totalForItem
                
                //print(self.totalPrice)
                //print("update")
                
                cell = summaryCell
            }
        } else if indexPath.section == 2 {
            let rentTimeCell = self.itemSummaryTable.dequeueReusableCell(withIdentifier: "RentTimeCell", for: indexPath) as! RentTimeCell
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "th_TH")
            dateFormatter.dateFormat = "d LLLL yyyy"
            
            var itemCount = 0
            var totalPrice = 0.0
            
            for data in self.orderItems! {
                itemCount += data.productRent
                totalPrice += Double(data.totalForItem)!
            }
            
            let diffInDays = Calendar.current.dateComponents([.day], from: self.orderDates!.firstDate, to: self.orderDates!.finalDate).day
            
            rentTimeCell.dateTimeStart.text = dateFormatter.string(from: self.orderDates!.firstDate)
            rentTimeCell.dateTimeEnd.text = dateFormatter.string(from: self.orderDates!.finalDate)
            rentTimeCell.rentDuration.text = "\(String(diffInDays!)) วัน"
            rentTimeCell.itemAmount.text = "\(String(self.orderItems!.count)) รายการ"
            rentTimeCell.totalAmount.text = String(itemCount)
            cell = rentTimeCell
        } else {
           let summaryPriceCell = self.itemSummaryTable.dequeueReusableCell(withIdentifier: "SummaryCell", for: indexPath) as! SummaryCell
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            // localize to your grouping and decimal separator
            currencyFormatter.locale = Locale(identifier: "th_TH")

            // We'll force unwrap with the !, if you've got defined data you may need more error checking

            var itemCount = 0
            var totalPrice = 0.0
            
            for data in self.orderItems! {
                itemCount += data.productRent
                totalPrice += Double(data.totalForItem)!
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "th_TH")
            dateFormatter.dateFormat = "d LLLL yyyy"
            
            let diffInDays = Calendar.current.dateComponents([.day], from: self.orderDates!.firstDate, to: self.orderDates!.finalDate).day
            
            summaryPriceCell.totalPricePerDay.text = currencyFormatter.string(from: NSNumber(value: totalPrice))!
            summaryPriceCell.totalPriceAll.text = currencyFormatter.string(from: NSNumber(value: totalPrice * Double(diffInDays!)))!
            summaryPriceCell.taxPrice.text = currencyFormatter.string(from: NSNumber(value: totalPrice * Double(diffInDays!) * 0.07))!
            summaryPriceCell.almostTotalPrice.text = currencyFormatter.string(from: NSNumber(value: totalPrice * Double(diffInDays!) + totalPrice * Double(diffInDays!) * 0.07))!
            
            cell = summaryPriceCell
        }
        return cell!
    }
}

extension OrderSummayController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
