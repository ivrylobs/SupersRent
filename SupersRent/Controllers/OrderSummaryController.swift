import UIKit
import OmiseSDK

class OrderSummaryController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func backToHome(_ sender: UIButton) {
        let presenterVC = self.presentingViewController?.presentingViewController as? HomeController
        presenterVC?.dismiss(animated: true, completion: nil)
    }
    @IBAction func paymentButton(_ sender: UIButton) {
        let publicKey = "pkey_test_5hj4rm25gafqtbn3e0m"
        let creditCardView = CreditCardFormViewController.makeCreditCardFormViewController(withPublicKey: publicKey)
        creditCardView.delegate = self
        creditCardView.handleErrors = true
        creditCardView.modalPresentationStyle = .fullScreen
        self.present(creditCardView, animated: true, completion: nil)
    }
    
}

extension OrderSummaryController: CreditCardFormViewControllerDelegate {
    func creditCardFormViewController(_ controller: CreditCardFormViewController, didSucceedWithToken token: Token) {
        print("Token_ID: \(token.id)")
        controller.dismiss(animated: true, completion: nil)
    }
    
    func creditCardFormViewController(_ controller: CreditCardFormViewController, didFailWithError error: Error) {
        print(error)
    }
    
    func creditCardFormViewControllerDidCancel(_ controller: CreditCardFormViewController) {
        print("Cancel")
    }
}
