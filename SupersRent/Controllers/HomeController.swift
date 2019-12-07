import UIKit
import SwiftUI
import KDCalendar

class HomeController: UIViewController {
    
    var groupData: [GroupModel]?
    var locationData: [LocationModel]?
    
    var getGroupData = GetGroupData()
    var getLocationData = GetLocationData()
    
    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getGroupData.delegate = self
        self.getLocationData.delegate = self
        
    }
    
    @IBAction func presentViewAction(_ sender: UIButton) {
        
        switch sender.accessibilityIdentifier! {
        case NameConstant.ButtonID.groupID :
            print(sender.accessibilityIdentifier!)
            self.getGroupData.getGroup()
        case NameConstant.ButtonID.locationID :
            self.getLocationData.getLocation()
            print(sender.accessibilityIdentifier!)
        case NameConstant.ButtonID.dateID :
            print(sender.accessibilityIdentifier!)
            self.performSegue(withIdentifier: NameConstant.SegueID.dateId, sender: self)
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
           
        }
        
    }
    
}

extension HomeController: GetGroupDataDelegate {
    func didGetGroupData(groupData: [GroupModel]) {
        print("GetGroupData")
        DispatchQueue.main.async {
            self.groupData = groupData
            self.performSegue(withIdentifier: NameConstant.SegueID.groupID, sender: self)
        }
    }
}

extension HomeController: GetLocationDataDelegate {
    func didGetLocationData(locationData: [LocationModel]) {
        print("GetLocationData")
        DispatchQueue.main.async {
            self.locationData = locationData
            self.performSegue(withIdentifier: NameConstant.SegueID.locationID, sender: self)
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
