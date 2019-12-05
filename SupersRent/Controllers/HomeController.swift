//
//  HomeController.swift
//  SupersRent
//
//  Created by ivrylobs on 4/12/2562 BE.
//  Copyright © 2562 banraomaibab. All rights reserved.
//

import SwiftUI
import UIKit
import Foundation


class HomeController: UIViewController {
    
    
    //MARK: Object Declare.
    @IBOutlet var SuperView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SuperView.backgroundColor = UIColor(rgb: ColorString.BlackGrey)
    }
    
}


//MARK: Previews and UIRepresntative.
struct HomeViewContainer: UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<HomeViewContainer>) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "Home")
    }
    
    func updateUIViewController(_ uiViewController: HomeViewContainer.UIViewControllerType, context: UIViewControllerRepresentableContext<HomeViewContainer>) {
    }
}

struct HomeController_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewContainer().previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
}
