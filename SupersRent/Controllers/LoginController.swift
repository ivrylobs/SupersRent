import UIKit
import Locksmith
import Alamofire
import SwiftyJSON

class LoginController: UIViewController {
	
	@IBOutlet weak var usernameField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	
	let loginUrl = "https://api.supersrent.com/app-user/api/home/auth/login"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.usernameField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "BlackGray")!])
		self.passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "BlackGray")!])
		
		//Set if user touch outside the keyboard, going to disappear.
		hideKeyboardWhenTappedAround()
		
		//Data protocal delegate.
		self.usernameField.delegate = self
		self.passwordField.delegate = self
	}
	
	@IBAction func loginToServer(_ sender: Any) {
		doLogin()
	}
	
	
	@IBAction func backToOrder(_ sender: UIButton) {
		let presenter = self.presentingViewController
		if presenter?.restorationIdentifier! == NameConstant.StoryBoardID.homeID {
			presenter?.viewDidLoad()
			self.dismiss(animated: true, completion: nil)
		} else {
			self.dismiss(animated: true, completion: nil)
		}
	}
	
	func doLogin() {
		
		//Set login Parameters.
		let param: [String:String] = ["email": usernameField.text!, "password": passwordField.text!]
		
		Alamofire.request(self.loginUrl, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { response in
			switch response.result {
				case .success(let data):
					
					//Hold Process for do HTTP Tasks.
					DispatchQueue.main.async {
						
						//Retrieve data from http response.
						let jsonData = JSON(data)
						
						//Check if retrieved data correct.
						if let tokenType = jsonData["tokenType"].string, let tokenAccess = jsonData["accessToken"].string {
							print(tokenType)
							print(tokenAccess)
							
							//Update Userdata and get back to the presenter.
							self.updateUserData(userData: ["isLogin": true, "tokenAccess": "\(tokenType) \(tokenAccess)", "email": "\(self.usernameField.text!)", "userData": ""])
							
							//Check if presenter not home, do another presenter instead.
							let presenter = self.presentingViewController
							if presenter?.restorationIdentifier! == NameConstant.StoryBoardID.homeID {
								presenter?.viewDidLoad()
								self.dismiss(animated: true, completion: nil)
							} else {
								self.updateUserDataForKeyToken()
								self.dismiss(animated: true) {
									presenter?.performSegue(withIdentifier: NameConstant.SegueID.itemToSummayID, sender: presenter)
								}
							}
						} else {
							
							//Update userData to default state
							self.updateUserData(userData: ["isLogin": false, "tokenAccess": "", "email": "", "userData": ""])
							
							//Show output to console and Alert user.
							print("Login Failed")
							self.showAlertFill()
						}
				}
				case .failure(let error):
					print(error)
			}
		}
	}
	
	func updateUserData(userData: [String: Any]) {
		do {
			try Locksmith.updateData(data: userData, forUserAccount: "admin")
		} catch {
			print(error)
		}
	}
	
	func updateUserDataForKeyToken() {
		let loadedData = Locksmith.loadDataForUserAccount(userAccount: "admin")
		var userData = JSON(loadedData!)
		let url = "https://api.supersrent.com/app-user/api/customer/getProfile/\(userData["email"].stringValue)"
		let header = ["Accept":"application/json","AuthorizationHome": userData["tokenAccess"].stringValue]
		
		Alamofire.request(url, method: .get, headers: header).responseJSON { response in
			switch response.result {
				case .success(let data):
					
					DispatchQueue.main.async {
						let jsonData = JSON(data)
						userData["userData"] = JSON(jsonData)
						self.updateUserData(userData: userData.dictionaryObject!)
				}
				case .failure(let error):
					print(error)
			}
		}
	}
	
	func showAlertFill() {
		// create the alert
		let alert = UIAlertController(title: "ล้มเหลว", message: "Email หรือ Password ผิด", preferredStyle: UIAlertController.Style.alert)
		
		// add an action (button)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
		
		// show the alert
		self.present(alert, animated: true, completion: nil)
	}
}

extension LoginController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField.restorationIdentifier! == NameConstant.TextFieldID.userNameID {
			
			//This Textfield end editing.
			textField.endEditing(true)
			
			//Set the next textField to becomeFirstResponder.
			self.passwordField.becomeFirstResponder()
			
		} else {
			
			//End editing before do login.
			textField.endEditing(true)
			
			//Login
			doLogin()
		}
		return true
	}
}
