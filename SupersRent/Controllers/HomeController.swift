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
    var userData: JSON?
    
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
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        
        if Locksmith.loadDataForUserAccount(userAccount: "admin") == nil {
            print("nil ....")
            do {
                try Locksmith.saveData(data: ["isLogin": false, "tokenAccess": "", "email": "", "userData": ""], forUserAccount: "admin")
            } catch {
                print(error)
            }
        }
        super.viewDidLoad()
        
        //Protocal Delegate.
        self.getGroupData.delegate = self
        self.getLocationData.delegate = self
        self.getProductData.delegate = self
        
        //Prepare Data for get UserInfo
        let userData = Locksmith.loadDataForUserAccount(userAccount: "admin")
        let returnUserData = JSON(userData!)
        self.userData = returnUserData
        let url = "https://api.supersrent.com/app-user/api/customer/getProfile/\(returnUserData["email"].stringValue)"
        let header = ["Accept":"application/json","AuthorizationHome": returnUserData["tokenAccess"].stringValue]
        
        if let isLogin = returnUserData["isLogin"].bool {
            if isLogin {
                Alamofire.request(url, method: .get, headers: header).responseJSON { response in
                    switch response.result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            let userData = JSON(data)
                            if let firstName = userData["firstName"].string {
                                print("Logged")
                                self.profileLabel.text = firstName
                                self.userData!["userData"] = JSON(userData)
                                do {
                                    try Locksmith.updateData(data: self.userData!.dictionaryObject!, forUserAccount: "admin")
                                } catch {
                                    print(error)
                                }
                            } else {
                                do {
                                    try Locksmith.updateData(data: ["isLogin": false, "tokenAccess": "", "email": "", "userData": ""], forUserAccount: "admin")
                                    self.profileLabel.text = "Not login"
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    case .failure(let error):
                        print("\(error)please login!")
                        self.profileLabel.text = "Not login"
                    }
                }
            } else {
                print("please login!")
                self.profileLabel.text = "Not login"
            }
        } else {
            print("Please login!")
            self.profileLabel.text = "Not login"
            
            do {
                try Locksmith.updateData(data: ["isLogin": false, "tokenAccess": "", "email": "", "userData": ""], forUserAccount: "admin")
                self.profileLabel.text = "Not login"
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func gotoLogin(_ sender: UIButton) {
        let loadedData = Locksmith.loadDataForUserAccount(userAccount: "admin")
        let userData = JSON(loadedData!)
        if userData["isLogin"].boolValue {
            print("Now are Login")
        }
        self.performSegue(withIdentifier: NameConstant.SegueID.homeToLoginID, sender: self)
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
                self.showAlertFill()
            } else {
                self.getProductData.getProduct()
            }
        default:
            print("Not found")
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
    
    func showAlertFill() {
        // create the alert
        let alert = UIAlertController(title: "ข้อมูลไม่ครบ", message: "กรุณากรอกข้อมูลให้ครบ", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
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
