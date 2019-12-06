//
//  ViewController.swift
//  SupersRent
//
//  Created by dmelab15 on 2/12/2562 BE.
//  Copyright © 2562 banraomaibab. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import OmiseSDK
import SwiftUI

class ViewController: UIViewController, CreditCardFormViewControllerDelegate{
    
    //MARK: Access key from Omise to send the request of payment.
    private let publicKey = "pkey_test_123"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    

    @IBAction func gotoOmisePayment(_ sender: UIButton) {
        
        let creditCardView = CreditCardFormViewController.makeCreditCardFormViewController(withPublicKey: publicKey)
        creditCardView.delegate = self
        creditCardView.handleErrors = true
        creditCardView.modalPresentationStyle = .fullScreen
        present(creditCardView, animated: true, completion: nil)
    }
    
    func creditCardFormViewControllerDidCancel(_ controller: CreditCardFormViewController) {
           dismiss(animated: true, completion: nil)
       }
       
     func creditCardFormViewController(_ controller: CreditCardFormViewController, didSucceedWithToken token: Token) {
       dismiss(animated: true, completion: nil)

       // Sends `Token` to your server to create a charge, or a customer object.
     }

     func creditCardFormViewController(_ controller: CreditCardFormViewController, didFailWithError error: Error) {
       dismiss(animated: true, completion: nil)

       // Only important if we set `handleErrors = false`.
       // You can send errors to a logging service, or display them to the user here.
     }
}

//MARK: Create Storyboard Container as View.

@available(iOS 13.0, *)
struct StoryBoardContainer: UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<StoryBoardContainer>) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "Payment")
    }
    
    func updateUIViewController(_ uiViewController: StoryBoardContainer.UIViewControllerType, context: UIViewControllerRepresentableContext<StoryBoardContainer>) {
    }
}

//MARK: Previews Method of SwiftUI.

@available(iOS 13.0.0, *)
struct View_Previews: PreviewProvider {
    
    static var previews: some View {
        StoryBoardContainer().previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
}


