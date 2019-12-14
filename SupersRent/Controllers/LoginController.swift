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
        
        hideKeyboardWhenTappedAround()
        
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
        let param: [String:String] = ["email": usernameField.text!, "password": passwordField.text!]
        
        Alamofire.request(self.loginUrl, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let data):
                DispatchQueue.main.async {
                    let jsonData = JSON(data)
                    if let tokenType = jsonData["tokenType"].string, let tokenAccess = jsonData["accessToken"].string {
                        print(tokenType)
                        print(tokenAccess)
                        do {
                            try Locksmith.updateData(data: ["isLogin": true, "tokenAccess": "\(tokenType) \(tokenAccess)", "email": "\(self.usernameField.text!)", "userData": ""], forUserAccount: "admin")
                            let presenter = self.presentingViewController
                            if presenter?.restorationIdentifier! == NameConstant.StoryBoardID.homeID {
                                presenter?.viewDidLoad()
                                self.dismiss(animated: true, completion: nil)
                            } else {
                                self.doUpdateIfLoginFromOrder()
                                self.dismiss(animated: true) {
                                    presenter?.performSegue(withIdentifier: NameConstant.SegueID.itemToSummayID, sender: presenter)
                                }
                            }
                        } catch {
                            print(error)
                        }
                    } else {
                        do {
                            try Locksmith.updateData(data: ["isLogin": false, "tokenAccess": "", "email": "", "userData": ""], forUserAccount: "admin")
                        } catch {
                            print(error)
                        }
                        print("Login Failed")
                        self.showAlertFill()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
    
    func doUpdateIfLoginFromOrder() {
        let userData = Locksmith.loadDataForUserAccount(userAccount: "admin")
        var returnUserData = JSON(userData!)
        let url = "https://api.supersrent.com/app-user/api/customer/getProfile/\(returnUserData["email"].stringValue)"
        let header = ["Accept":"application/json","AuthorizationHome": returnUserData["tokenAccess"].stringValue]
        
        Alamofire.request(url, method: .get, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                
                DispatchQueue.main.async {
                    let jsonData = JSON(data)
                    returnUserData["userData"] = JSON(jsonData)
                    do {
                        try Locksmith.updateData(data: returnUserData.dictionaryObject!, forUserAccount: "admin")
                    } catch {
                        print(error)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                }
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
        print("return")
        if textField.restorationIdentifier! == NameConstant.TextFieldID.userNameID {
            textField.endEditing(true)
            self.passwordField.becomeFirstResponder()
        } else {
            textField.endEditing(true)
            doLogin()
        }
        return true
    }
}
