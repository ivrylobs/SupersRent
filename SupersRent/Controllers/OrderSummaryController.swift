import UIKit

class OrderSummaryController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func backToHome(_ sender: UIButton) {
        let presenterVC = self.presentingViewController?.presentingViewController as? HomeController
        presenterVC?.dismiss(animated: true, completion: nil)
    }
}
