import UIKit
import SwiftUI
import KDCalendar

class HomeController: UIViewController {
    
    //Optional Variables for passing to other Controller.
    var groupData: [GroupModel]?
    var locationData: [LocationModel]?
    var searchProductData: [CategoryProduct]?
    
    //Create GetData Object.
    var getGroupData = GetGroupData()
    var getLocationData = GetLocationData()
    var getProductData = GetProductData()
    
    //Create SearchParam.
    var searchGroup: GroupModel?
    var searchLocation: LocationModel?
    var searchDate: DateModel?
    
    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getGroupData.delegate = self
        self.getLocationData.delegate = self
        self.getProductData.delegate = self
        
    }
    
    @IBAction func presentViewAction(_ sender: UIButton) {
        
        switch sender.accessibilityIdentifier! {
        case NameConstant.ButtonID.groupID :
            self.getGroupData.getGroup()
        case NameConstant.ButtonID.locationID :
            self.getLocationData.getLocation()
        case NameConstant.ButtonID.dateID :
            self.performSegue(withIdentifier: NameConstant.SegueID.dateId, sender: self)
        case NameConstant.ButtonID.searchID :
            if self.searchGroup == nil || self.searchLocation == nil || self.searchDate == nil {
                self.showAlertFill()
            } else {
                self.getProductData.getProduct()
            }
        default:
            print("Not Match to any")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == NameConstant.SegueID.groupID {
            let destinationVC = segue.destination as? GroupController
            destinationVC?.rowData = self.groupData
        } else if segue.identifier == NameConstant.SegueID.locationID {
            let destinationVC = segue.destination as? LocationController
            destinationVC?.rowData = self.locationData
        } else if segue.identifier == NameConstant.SegueID.dateId {
            
        } else if segue.identifier == NameConstant.SegueID.searchID {
            let destinationVC = segue.destination as? SearchItemController
            destinationVC?.productData = self.searchProductData
            destinationVC?.searchGroup = self.searchGroup
            destinationVC?.searchLocation = self.searchLocation
            destinationVC?.searchDate = self.searchDate
        }
        
    }
    
    func showAlertFill() {
        // create the alert
        let alert = UIAlertController(title: "Please Choose!", message: "This is my message.", preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension HomeController {
    func checkSearchParam() {
        
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
            self.searchProductData = productData
            self.performSegue(withIdentifier: NameConstant.SegueID.searchID, sender: self)
        }
    }
}

struct Home_Previews: PreviewProvider {
    
    struct HomeContentView: UIViewControllerRepresentable {
        func makeUIViewController(context: UIViewControllerRepresentableContext<Home_Previews.HomeContentView>) -> UIViewController {
            return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "HomeScene")
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<Home_Previews.HomeContentView>) {
            
        }
    }
    
    static var previews: some View {
        HomeContentView().previewDevice(PreviewDevice(rawValue: "iPhone SE"))
    }
}
