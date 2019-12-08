import UIKit
import SwiftUI

class GroupController: UIViewController {
    
    var rowData: [GroupModel]?
    
    @IBOutlet weak var groupTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.groupTable.dataSource = self
        self.groupTable.delegate = self
        
    }
    
    @IBAction func BackToHome(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension GroupController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowData?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.groupTable.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        let rowLabel = rowData!
        cell.textLabel?.text = "\(rowLabel[indexPath.row].groupName)"
        return cell
    }
}

extension GroupController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let presenter = presentingViewController as? HomeController {
            presenter.groupButton.setTitle(self.groupTable.cellForRow(at: indexPath)?.textLabel?.text!, for: .normal)
            presenter.searchGroup = self.rowData![indexPath.row]
        }
        
        dismiss(animated: true, completion: nil)
    }
}
