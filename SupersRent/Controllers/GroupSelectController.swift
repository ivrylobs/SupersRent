import UIKit

class GroupSelectController: UIViewController {
    
    var rowData: [GroupModel]?
    
    @IBOutlet weak var groupTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//Setup Data protocal delegates.
        self.groupTable.dataSource = self
        self.groupTable.delegate = self
		
		//Set table Footer As Empty View.
		self.groupTable.tableFooterView = UIView()
    }
    
    @IBAction func BackToHome(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension GroupSelectController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.rowData!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.groupTable.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
		let rowLabel = self.rowData!
        cell.textLabel?.text = "\(rowLabel[indexPath.row].groupName)"
		cell.textLabel?.textColor = UIColor(named: "BlackGray")
        return cell
    }
}

extension GroupSelectController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if let presenter = (presentingViewController as? UITabBarController)?.viewControllers![0] as? HomeController {
			print("here")
			presenter.groupButton.setTitle("    \(self.rowData![indexPath.row].groupName)", for: .normal)
            presenter.searchGroup = self.rowData![indexPath.row]
		} else {
			print("Failed to access presentingViewController")
		}

        dismiss(animated: true, completion: nil)
    }
}
