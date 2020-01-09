//
//  LogoutController.swift
//  SupersRent
//
//  Created by ivrylobs on 9/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import Foundation
import UIKit
import Locksmith

class LogoutController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	@IBAction func logOut(_ sender: UIButton) {
		
		self.updateUserData(userData: ["isLogin": false, "tokenAccess": "", "email": "", "userData": ""])
		
		let parent = self.parent as? UITabBarController
		
		let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginView")
		
		var viewControllers = parent?.viewControllers
		viewControllers![3] = vc!
		
		//Show output to console and Alert user.
		print("Logged Out")
		parent?.setViewControllers(viewControllers, animated: true)

	}
	
	func updateUserData(userData: [String: Any]) {
		do {
			try Locksmith.updateData(data: userData, forUserAccount: "admin")
		} catch {
			print(error)
		}
	}
}
