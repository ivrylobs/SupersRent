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
	
	//HTTP Parameters
	var header: HTTPHeaders?
	
	@IBOutlet weak var pricePerDay: UILabel!
	@IBOutlet weak var rentDuration: UILabel!
	@IBOutlet weak var taxPrice: UILabel!
	@IBOutlet weak var totalPrice: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Create Formatter for currency.
		let currencyFormatter = NumberFormatter()
		currencyFormatter.usesGroupingSeparator = true
		currencyFormatter.numberStyle = .currency
		
		// localize to your grouping and decimal separator
		currencyFormatter.locale = Locale(identifier: "th_TH")
		
		//Set textLabel as currency.
		self.pricePerDay.text = currencyFormatter.string(from: NSNumber(value: self.rentPricePerDay!))!
		self.rentDuration.text = currencyFormatter.string(from: NSNumber(value: self.priceDurationRent!))!
		self.taxPrice.text = currencyFormatter.string(from: NSNumber(value: self.priceDurationRent! * 0.07))!
		self.totalPrice.text = currencyFormatter.string(from: NSNumber(value: self.payPrice!))!
		
		//Setup HTTPHeaders.
		let loadedData = JSON(Locksmith.loadDataForUserAccount(userAccount: "admin")!)
		self.header = ["Accept":"application/json","AuthorizationHome": loadedData["tokenAccess"].stringValue]
	}
	
	@IBAction func paymentNowButton(_ sender: UIButton) {
		
		//Show output to console debuging.
		print("Press PayNow")
		
		//Set public key for Omise.
		let publicKey = "pkey_test_5i8idrim1dwxe878yr2"
		
		//Create CreditCardView.
		let creditCardView = CreditCardFormViewController.makeCreditCardFormViewController(withPublicKey: publicKey)
		
		//Set Protocal and delegate.
		creditCardView.delegate = self
		creditCardView.handleErrors = true
		
		//Prepare before presenting.
		creditCardView.modalPresentationStyle = .popover
		
		//Present.
		self.present(creditCardView, animated: true, completion: nil)
	}
	
	@IBAction func payAfterButton(_ sender: UIButton) {
		
		print("Press PayLater")
		
		let urlOrder = "https://api.supersrent.com/app-user/api/order/addCustomerOrderDetail/\(self.orderID!)"
		let urlPDF = "https://api.supersrent.com/app-user/api/order/ganaratePdfOrderDetail/\(self.orderID!)"
		let urlFinish = "https://api.supersrent.com/app-user/api/order/addCustomerOrderDetail/finish/\(self.orderID!)"
		let parameters: [String: Any] = [
			"orderPaymentType": "paymentLater"
		]
		
		self.requestAPIWithBody(apiURL: urlOrder, httpMethod: .put, httpBody: parameters, httpHeader: self.header!) { jsonOrder in
			if jsonOrder["message"].stringValue == "Successfully" {
				self.requestAPI(apiURL: urlPDF, httpMethod: .post, httpHeader: self.header!) { jsonPDF in
					if jsonPDF["message"].stringValue == "GanaratePdfSuccessfully" {
						
						let finishParameters: [String: Any] = [
							"orderStatus": true
						]
						
						self.requestAPIWithBody(apiURL: urlFinish, httpMethod: .put, httpBody: finishParameters, httpHeader: self.header!) { jsonFinish in
							
							if jsonFinish["message"] == "Successfully" {
								self.showAlertForOrderCompleted()
							} else {
								print("failed")
							}
						}
						
					} else {
						print("error")
					}
				}
			} else {
				print("error")
			}
		}
	}
}

extension OrderPaymentController: CreditCardFormViewControllerDelegate {
	func creditCardFormViewController(_ controller: CreditCardFormViewController, didSucceedWithToken token: Token) {
		DispatchQueue.main.async {
			
			print("Token_ID: \(token.id)")
			
			let omiseUrl = "https://api.supersrent.com/app-user/api/order/payment"
			let saveOmiseUrl = "https://api.supersrent.com/app-user/api/order/orderPeyment"
			let saveOrderDetailUrl = "https://api.supersrent.com/app-user/api/order/addCustomerOrderDetail/\(self.orderID!)"
			
			let paramOmise: [String: Any] = [
				"productTotal": self.payPrice! * 100,
				"orderId": self.orderID!,
				"omiseToken": token.id
			]
			
			self.requestAPIWithBody(apiURL: omiseUrl, httpMethod: .post, httpBody: paramOmise, httpHeader: self.header!) { jsonOmise in
				if jsonOmise["chargeStatus"].stringValue == "pending" {
					
					let refIDParameters: [String: Any] = [
						"chargeId": jsonOmise["chargeId"].stringValue,
						"orderId": self.orderID!,
						"referenceId": jsonOmise["referenceId"].stringValue
					]
					
					self.requestAPIWithBody(apiURL: saveOmiseUrl, httpMethod: .post, httpBody: refIDParameters, httpHeader: self.header!) { jsonSaveOmise in
						if jsonSaveOmise["message"].stringValue == "successfully" {
							
							let orderDetail: [String: Any] = [
								"orderPaymentType": "paymentNow",
								"orderPaymentStatus": jsonOmise["chargeStatus"].stringValue,
								"orderPaymentChargeId": jsonOmise["chargeId"].stringValue,
								"orderPaymentTransaction": jsonOmise["chargeTransaction"].stringValue
							]
							
							self.requestAPIWithBody(apiURL: saveOrderDetailUrl, httpMethod: .put, httpBody: orderDetail, httpHeader: self.header!) { jsonSaveOrder in
								if jsonSaveOrder["message"].stringValue == "Successfully" {
									
									let authorizeURL: URL = URL(string: jsonOmise["chargeAuthorizeUri"].stringValue)!
									let exceptUrlReturn: [URLComponents] = [URLComponents(string: "https://www.supersrent.com/checkout/order-payment")!]
									
									let handlerController = AuthorizingPaymentViewController.makeAuthorizingPaymentViewControllerWithAuthorizedURL(authorizeURL, expectedReturnURLPatterns: exceptUrlReturn, delegate: self)
									controller.present(handlerController, animated: true, completion: nil)
								} else {
									print("error")
								}
							}
							
						} else {
							print("error")
						}
					}
					
				} else {
					let alert = UIAlertController(title: "ผิดพลาด", message: "เกิดข้อผิดพลาดระหว่างทำรายการชำระเงิน, กรุณาเลือกชำระภายหลัง", preferredStyle: UIAlertController.Style.alert)
					
					// add an action (button)
					alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in controller.dismiss(animated: true, completion: nil)}))
					// show the alert
					self.present(alert, animated: true, completion: nil)
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

extension OrderPaymentController: AuthorizingPaymentViewControllerDelegate {
	func authorizingPaymentViewController(_ viewController: AuthorizingPaymentViewController, didCompleteAuthorizingPaymentWithRedirectedURL redirectedURL: URL) {
		
		if redirectedURL.absoluteString != "" {
			
			let redirectUrl = "https://api.supersrent.com/app-user/api/order/getOrderPeyment/\(getQueryStringParameter(url: redirectedURL.absoluteString, param: "ref_id")!)"
			
			self.requestAPI(apiURL: redirectUrl, httpMethod: .get, httpHeader: self.header!) { jsonRef in
				
				let chargeIdUrl = "https://api.supersrent.com/app-user/api/order/getOrderPeyment/Charge/\(jsonRef["chargeId"].stringValue)"
				
				self.requestAPI(apiURL: chargeIdUrl, httpMethod: .get, httpHeader: self.header!) { jsonCharge in
					
					if jsonCharge.arrayValue[0]["data"]["status"].stringValue == "successful" {
						
						let urlPDF = "https://api.supersrent.com/app-user/api/order/ganaratePdfOrderDetail/\(self.orderID!)"
						
						self.requestAPI(apiURL: urlPDF, httpMethod: .post, httpHeader: self.header!) { jsonPDF in
							
							if jsonPDF["message"].stringValue == "GanaratePdfSuccessfully" {
								
								let finishParameters: [String: Any] = [
									"orderStatus": true
								]
								
								let urlFinish = "https://api.supersrent.com/app-user/api/order/addCustomerOrderDetail/finish/\(self.orderID!)"
								
								self.requestAPIWithBody(apiURL: urlFinish, httpMethod: .put, httpBody: finishParameters, httpHeader: self.header!) { jsonFinish in
									
									if jsonFinish["message"] == "Successfully" {
										viewController.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
										self.showAlertForOrderCompleted()
									} else {
										print("failed")
									}
								}
								
							} else {
								print("error")
							}
						}
					}
				}
			}
		} else {
			print("Failed")
		}
	}
	
	func authorizingPaymentViewControllerDidCancel(_ viewController: AuthorizingPaymentViewController) {
		print("didCancel")
	}
	
	func getQueryStringParameter(url: String, param: String) -> String? {
		guard let url = URLComponents(string: url) else { return nil }
		return url.queryItems?.first(where: { $0.name == param })?.value
	}
	
}

extension OrderPaymentController {
	func requestAPIWithBody(apiURL: URLConvertible, httpMethod: HTTPMethod, httpBody: Parameters, httpHeader: HTTPHeaders, handler: @escaping (JSON) -> Void) {
		Alamofire.request(apiURL, method: httpMethod, parameters: httpBody, encoding: JSONEncoding.default, headers: httpHeader).responseJSON { response in
			DispatchQueue.main.async {
				switch response.result {
					case .success(let data):
						let json = JSON(data)
						print(json)
						handler(json)
					case .failure(let error):
						print(error)
				}
			}
		}
	}
	
	func requestAPI(apiURL: URLConvertible, httpMethod: HTTPMethod, httpHeader: HTTPHeaders, handler: @escaping (JSON) -> Void) {
		Alamofire.request(apiURL, method: httpMethod, headers: httpHeader).responseJSON { response in
			DispatchQueue.main.async {
				switch response.result {
					case .success(let data):
						let json = JSON(data)
						print(json)
						handler(json)
					case .failure(let error):
						print(error)
				}
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
