import UIKit
import OmiseSDK
import Alamofire
import Locksmith
import SwiftyJSON

class OrderPaymentController: UIViewController {
    
    var orderID: String?
    var payPrice: Double?
    
    @IBOutlet weak var pricePerDay: UIView!
    @IBOutlet weak var rentDuration: UIView!
    @IBOutlet weak var taxPrice: UIView!
    @IBOutlet weak var totalPrice: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
//        let loadedData = JSON(Locksmith.loadDataForUserAccount(userAccount: "admin")!)
//        let userData = loadedData["userData"].dictionaryValue
//        let urlOrder = "https://api.supersrent.com/app-user/api/order/addCustomerOrderDetail/finish/\(self.orderID!)"
//        let header = ["Accept":"application/json","AuthorizationHome": loadedData["tokenAccess"].stringValue]
//        let paramPut = ["orderStatus": true]
//        Alamofire.request(urlOrder, method: .put, parameters: <#T##Parameters?#>, encoding: <#T##ParameterEncoding#>, headers: <#T##HTTPHeaders?#>)
    }
    
}

extension OrderPaymentController: CreditCardFormViewControllerDelegate {
    func creditCardFormViewController(_ controller: CreditCardFormViewController, didSucceedWithToken token: Token) {
        print("Token_ID: \(token.id)")
        
        let loadedData = JSON(Locksmith.loadDataForUserAccount(userAccount: "admin")!)
        let omiseUrl = "https://api.supersrent.com/app-user/api/order/payment"
        let header = ["Accept":"application/json","AuthorizationHome": loadedData["tokenAccess"].stringValue]
        let paramOmise: [String: Any] = [
            "productTotal": self.payPrice!,
            "orderId": self.orderID!,
            "omiseToken": token.id
        ]
        
        Alamofire.request(omiseUrl, method: .post, parameters: paramOmise, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                print(json)
                controller.dismiss(animated: true, completion: nil)
            case .failure(let error):
                print(error)
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
