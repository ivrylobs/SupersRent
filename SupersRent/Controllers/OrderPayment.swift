import UIKit
import OmiseSDK
import Alamofire
import Locksmith
import SwiftyJSON

class OrderPaymentController: UIViewController {
	
	var orderID: String?
	
	var rentPricePerDay: Double?
	var priceDurationRent: Double?
	var dayRent: Int?
	var payPrice: Double?
	
	@IBOutlet weak var pricePerDay: UILabel!
	@IBOutlet weak var rentDuration: UILabel!
	@IBOutlet weak var taxPrice: UILabel!
	@IBOutlet weak var totalPrice: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let currencyFormatter = NumberFormatter()
		currencyFormatter.usesGroupingSeparator = true
		currencyFormatter.numberStyle = .currency
		// localize to your grouping and decimal separator
		currencyFormatter.locale = Locale(identifier: "th_TH")
		
		self.pricePerDay.text = currencyFormatter.string(from: NSNumber(value: self.rentPricePerDay!))!
		self.rentDuration.text = currencyFormatter.string(from: NSNumber(value: self.priceDurationRent!))!
		self.taxPrice.text = currencyFormatter.string(from: NSNumber(value: self.priceDurationRent! * 0.07))!
		self.totalPrice.text = currencyFormatter.string(from: NSNumber(value: self.payPrice!))!
	}
	
	@IBAction func backToHome(_ sender: UIButton) {
		let presenterVC = self.presentingViewController?.presentingViewController as? HomeController
		presenterVC?.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func paymentButton(_ sender: UIButton) {
		print("Press PayNow")
		let publicKey = "pkey_test_5i8idrim1dwxe878yr2"
		let creditCardView = CreditCardFormViewController.makeCreditCardFormViewController(withPublicKey: publicKey)
		creditCardView.delegate = self
		creditCardView.handleErrors = true
		creditCardView.modalPresentationStyle = .automatic
		self.present(creditCardView, animated: true, completion: nil)
	}
	
	@IBAction func payAfter(_ sender: UIButton) {
		
		let urlOrder = "https://api.supersrent.com/app-user/api/order/addCustomerOrderDetail/finish/\(self.orderID!)"
		let loadedData = JSON(Locksmith.loadDataForUserAccount(userAccount: "admin")!)
		let header = ["Accept":"application/json","AuthorizationHome": loadedData["tokenAccess"].stringValue]
		let parameters: [String: Any] = [
			"orderStatus": true
		]
		
		Alamofire.request(urlOrder, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { response in
			switch response.result {
				case .success(let data):
					DispatchQueue.main.async {
						let json = JSON(data)
						if json["message"].stringValue == "Successfully" {
							self.showAlertForOrderCompleted()
						}
					}
				case .failure(let error):
					print(error)
			}
		}
	}
	
	func showAlertForOrderCompleted() {
		// create the alert
		let alert = UIAlertController(title: "การทำรายสำเร็จ", message: "คุณได้ทำการสั่งซื้อเรียบร้อยแล้ว", preferredStyle: UIAlertController.Style.alert)
		
		// add an action (button)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in self.backToHome()}))
		// show the alert
		self.present(alert, animated: true, completion: nil)
	}
	
	func backToHome() {
		self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
	}
	
}

extension OrderPaymentController: CreditCardFormViewControllerDelegate {
	func creditCardFormViewController(_ controller: CreditCardFormViewController, didSucceedWithToken token: Token) {
		DispatchQueue.main.async {
			print("Token_ID: \(token.id)")
			let loadedData = JSON(Locksmith.loadDataForUserAccount(userAccount: "admin")!)
			let omiseUrl = "https://api.supersrent.com/app-user/api/order/payment"
			let header = ["Accept":"application/json","AuthorizationHome": loadedData["tokenAccess"].stringValue]
			let paramOmise: [String: Any] = [
				"productTotal": self.payPrice! * 100,
				"orderId": self.orderID!,
				"omiseToken": token.id
			]
			
			Alamofire.request(omiseUrl, method: .post, parameters: paramOmise, encoding: JSONEncoding.default, headers: header).responseJSON { response in
				switch response.result {
					case .success(let data):
						DispatchQueue.main.async {
							let json = JSON(data)
							print(json)
							if json["chargeStatus"].stringValue == "pending" {
								controller.dismiss(animated: true, completion: nil)
								self.showAlertForOrderCompleted()
							} else {
								let alert = UIAlertController(title: "ผิดพลาด", message: "เกิดข้อผิดพลาดระหว่างทำรายการชำระเงิน, กรุณาเลือกชำระภายหลัง", preferredStyle: UIAlertController.Style.alert)
								
								// add an action (button)
								alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in controller.dismiss(animated: true, completion: nil)}))
								// show the alert
								self.present(alert, animated: true, completion: nil)
							}
						}
					case .failure(let error):
						print(error)
				}
			}
		}
	}
	
	func creditCardFormViewController(_ controller: CreditCardFormViewController, didFailWithError error: Error) {
		print(error)
	}
	
	func creditCardFormViewControllerDidCancel(_ controller: CreditCardFormViewController) {
		print("Cancel")
	}
}
