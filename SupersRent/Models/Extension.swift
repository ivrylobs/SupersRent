import UIKit
import SwiftUI

//MARK: Hex RGB Extension
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

//MARK: UIKit Keyboard Gesture Dismiss
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: URL Extension to query out only parameter value.
extension URL {
	public var queryParameters: [String: String]? {
		guard
			let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
			let queryItems = components.queryItems else { return nil }
		return queryItems.reduce(into: [String: String]()) { (result, item) in
			result[item.name] = item.value
		}
	}
}

//MARK: Boolean Converter Extension
extension Bool
{
    init(_ intValue: Int)
    {
        switch intValue
        {
        case 0:
            self.init(false)
        default:
            self.init(true)
        }
    }
}

struct ColorString {
    static let White:Int = 0xFDFFFC
    static let BlackGray:Int = 0x50514F
    static let RedCherry:Int = 0xF25F5C
    static let SupersRentYellow:Int = 0xFFE066
}
