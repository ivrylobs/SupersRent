import SwiftUI
import UIKit

class HomeController: UIViewController , GetGroupDataDelegate{
    
    var groupData: [GroupModel] = []
    
    @IBOutlet weak var CategoryButton: UIButton!
    @IBOutlet weak var LocationButton: UIButton!
    @IBOutlet weak var DateButton: UIButton!
    @IBOutlet var SuperView: UIView!
    
    var getGroupData = GetGroupData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGroupData.delegate = self
        CategoryButton.titleLabel?.textAlignment = .center
    }
    
    @IBAction func goToCategory(_ sender: UIButton) {
        
        switch sender.accessibilityIdentifier {
        case "CategoryButton":
            self.getGroupData.getProductGroup()
        case "LocationButton":
            performSegue(withIdentifier: "GotoLocation", sender: self)
        case "DateButton":
            performSegue(withIdentifier: "GotoDate", sender: self)
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
            print("Done")
        case "GotoDate":
            print("Done")
        default:
            print("Not Match to any identifier")
        }
    }
    
    func didGetGroupData(groupData: [GroupModel]) {
        DispatchQueue.main.async {
            self.groupData = groupData
            self.performSegue(withIdentifier: "GotoGroup", sender: self)
        }
    }
    
    
}

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
