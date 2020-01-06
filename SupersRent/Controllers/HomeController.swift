import UIKit
import KDCalendar
import Locksmith
import Alamofire
import SwiftyJSON

class HomeController: UIViewController {
	
	//Optional Variables for passing to other Controller.
	var groupData: [GroupModel]?
	var locationData: [LocationModel]?
	var itemData: [CategoryProduct]?
	var storeUserDataForUpdate: JSON?
	
	//Create GetData Object.
	var getGroupData = GetGroupData()
	var getLocationData = GetLocationData()
	var getProductData = GetProductData()
	
	//Create SearchParameter.
	var searchGroup: GroupModel?
	var searchLocation: LocationModel?
	var searchDate: DateModel?
	
	//Button object.
	@IBOutlet weak var groupButton: UIButton!
	@IBOutlet weak var locationButton: UIButton!
	@IBOutlet weak var dateButton: UIButton!
	@IBOutlet weak var searchButton: UIButton!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Initialize View design property
		
		//Initialize userData After Installed.
		self.appInitializerAfterInstalled()
		
		//Data Protocal Delegate.
		self.getGroupData.delegate = self
		self.getLocationData.delegate = self
		self.getProductData.delegate = self
		
		//Prepare Data for get UserInfo
		let loadedData = Locksmith.loadDataForUserAccount(userAccount: "admin")
		let userData = JSON(loadedData!)
		
		//Store userData for update.
		self.storeUserDataForUpdate = userData
		
		//Set HTTP Header.
		let url = "https://api.supersrent.com/app-user/api/customer/getProfile/\(userData["email"].stringValue)"
		let header = ["Accept":"application/json","AuthorizationHome": userData["tokenAccess"].stringValue]
		
		if let isLogin = userData["isLogin"].bool {
			if isLogin {
				Alamofire.request(url, method: .get, headers: header).responseJSON { response in
					switch response.result {
						case .success(let data):
							
							//Hold task while doing HTTP tasks.
							DispatchQueue.main.async {
								
								//Set data for save in local_userData.
								let userRetrievedData = JSON(data)
								
								//Check if retrieved data is correct.
								if userRetrievedData["firstName"].string != nil {
									
									//If Login process success show output to consoleใ
									print("Logged")
									
									//Set new data from retrieved to storeUserDataForUpdate.
									self.storeUserDataForUpdate!["userData"] = JSON(userRetrievedData)
									self.updateUserData(userData: self.storeUserDataForUpdate!.dictionaryObject!)
									
								} else {
									
									//If login not success update userData JSON to default state.
									self.updateUserData(userData: ["isLogin": false, "tokenAccess": "", "email": "", "userData": ""])
									print("Did not login before, please login again!")
								}
						}
						case .failure(let error):
							
							//If HTTP Task fail need to check backend.
							print("\(error) HTTP Task fail! Please Contact staff")
					}
				}
			} else {
				
				//If isLogin is false set default state immediately
				print("Did not login before, please login!")
			}
		} else {
			
			//If Initializer not working do initialize userData again.
			self.updateUserData(userData: ["isLogin": false, "tokenAccess": "", "email": "", "userData": ""])
			print("Please login!")
		}
	}
	
	@IBAction func presentViewAction(_ sender: UIButton) {
		
		switch sender.accessibilityIdentifier! {
			case NameConstant.ButtonID.groupID :
				self.getGroupData.getGroup()
			case NameConstant.ButtonID.locationID :
				self.getLocationData.getLocation()
			case NameConstant.ButtonID.dateID :
				self.performSegue(withIdentifier: NameConstant.SegueID.dateID, sender: self)
			case NameConstant.ButtonID.searchID :
				if self.searchGroup == nil || self.searchLocation == nil || self.searchDate == nil {
					self.showAlertForSearchParameters()
				} else {
					self.getProductData.getProduct()
			}
			default:
				print("Not found")
		}
	}
	
	func updateUserData(userData: [String : Any] ) {
		do {
			try Locksmith.updateData(data: userData, forUserAccount: "admin")
		} catch {
			print(error)
		}
	}
	
	func appInitializerAfterInstalled() {
		if Locksmith.loadDataForUserAccount(userAccount: "admin") == nil {
			print("nil ....")
			do {
				try Locksmith.saveData(data: ["isLogin": false, "tokenAccess": "", "email": "", "userData": ""], forUserAccount: "admin")
			} catch {
				print(error)
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == NameConstant.SegueID.groupID {
			let destinationVC = segue.destination as? GroupSelectController
			destinationVC?.rowData = self.groupData
		} else if segue.identifier == NameConstant.SegueID.locationID {
			let destinationVC = segue.destination as? LocationSelectController
			destinationVC?.rowData = self.locationData
		} else if segue.identifier == NameConstant.SegueID.dateID {
			print("There is no data for passing to DateSelectController!")
		} else if segue.identifier == NameConstant.SegueID.itemID {
			let destinationVC = segue.destination as? ItemSelectController
			destinationVC?.productData = self.itemData
			destinationVC?.searchGroup = self.searchGroup
			destinationVC?.searchLocation = self.searchLocation
			destinationVC?.searchDate = self.searchDate
		}
	}
	
	func showAlertForLogout() {
		// create the alert
		let alert = UIAlertController(title: "ออกจากระบบ", message: "คุณได้ออกจากระบบเรียบร้อยแล้ว", preferredStyle: UIAlertController.Style.alert)
		
		// add an action (button)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
		
		// show the alert
		self.present(alert, animated: true, completion: nil)
	}
	
	func showAlertForSearchParameters() {
		// create the alert
		let alert = UIAlertController(title: "ข้อมูลไม่ครบ", message: "กรุณากรอกข้อมูลให้ครบ", preferredStyle: UIAlertController.Style.alert)
		
		// add an action (button)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
		
		// show the alert
		self.present(alert, animated: true, completion: nil)
	}
	
	func setShadowForView(viewShadow: UIView, opacity: Float, offset: CGSize, radius: CGFloat) {
		viewShadow.layer.shadowColor = UIColor.gray.cgColor
		viewShadow.layer.shadowOpacity = opacity
		viewShadow.layer.shadowOffset = offset
		viewShadow.layer.shadowRadius = radius
		viewShadow.layer.masksToBounds = false
		viewShadow.layer.shadowPath = UIBezierPath(rect: viewShadow.bounds).cgPath
	}
	
}

extension HomeController: GetGroupDataDelegate {
	func didGetGroupData(groupData: [GroupModel]) {
		DispatchQueue.main.async {
			self.groupData = groupData
			self.performSegue(withIdentifier: NameConstant.SegueID.groupID, sender: self)
		}
	}
}

extension HomeController: GetLocationDataDelegate {
	func didGetLocationData(locationData: [LocationModel]) {
		DispatchQueue.main.async {
			self.locationData = locationData
			self.performSegue(withIdentifier: NameConstant.SegueID.locationID, sender: self)
		}
	}
}

extension HomeController: GetProductDataDelegate {
	func didGetProductData(productData: [CategoryProduct]) {
		DispatchQueue.main.async {
			self.itemData = productData
			self.performSegue(withIdentifier: NameConstant.SegueID.itemID, sender: self)
		}
	}
}
