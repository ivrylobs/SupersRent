import SwiftUI
import UIKit

class HomeController: UIViewController {
    
    var groupData: [GroupModel] = []
    var locationData: [LocationModel] = []
    
    var getGroupData = GetGroupData()
    var getLocationData = GetLocationData()
    
    @IBOutlet weak var CategoryButton: UIButton!
    @IBOutlet weak var LocationButton: UIButton!
    @IBOutlet weak var DateButton: UIButton!
    @IBOutlet var SuperView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getGroupData.delegate = self
        self.getLocationData.delegate = self
    }
    
    @IBAction func goToCategory(_ sender: UIButton) {
        
        switch sender.accessibilityIdentifier {
        case "CategoryButton":
            self.getGroupData.getProductGroup()
        case "LocationButton":
            self.getLocationData.getLocation()
        case "DateButton":
            let vc = UIHostingController(rootView: HostingSwiftUI())
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        default:
            print("Not Match to any identifier")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "GotoGroup":
            let destinationVC = segue.destination as! GroupController
            destinationVC.rowData = groupData
        case "GotoLocation":
            let destinationVC = segue.destination as! LocationController
            destinationVC.rowData = locationData
            //print(self.locationData)
        case "GotoDate":
            print("GotoDate")
        default:
            print("Not Match to any identifier")
        }
    }
}

extension HomeController: GetGroupDataDelegate, GetLocationDataDelegate {
    
    func didGetGroupData(groupData: [GroupModel]) {
        DispatchQueue.main.async {
            self.groupData = groupData
            self.performSegue(withIdentifier: "GotoGroup", sender: self)
        }
    }
    
    func didGetLocationData(locationData: [LocationModel]) {
        DispatchQueue.main.async {
            self.locationData = locationData
            self.performSegue(withIdentifier: "GotoLocation", sender: self)
        }
    }
}

@available(iOS 13.0, *)
struct HomeViewContainer: UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<HomeViewContainer>) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "Home")
    }
    
    func updateUIViewController(_ uiViewController: HomeViewContainer.UIViewControllerType, context: UIViewControllerRepresentableContext<HomeViewContainer>) {
        
    }
}

@available(iOS 13.0.0, *)
struct HomeController_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewContainer().previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
}
