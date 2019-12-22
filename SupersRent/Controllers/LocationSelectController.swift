import UIKit

class LocationSelectController: UIViewController {
    
    var rowData: [LocationModel]?
    var filteredRowData: [LocationModel]?
    
    @IBOutlet weak var LocationTable: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
		//Set data protocal delegate.
        self.LocationTable.delegate = self
        self.LocationTable.dataSource = self
        self.searchTextField.delegate = self
		
		//Set table attributes.
		self.searchTextField.attributedPlaceholder = NSAttributedString(string: "เลือกสถานที่", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "BlackGray")!])
		self.LocationTable.tableFooterView = UIView()
        
		//Set table data as default value.
		self.filteredRowData = self.rowData
		
    }
    
    @IBAction func BackToHomeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
        var countData = 0
		
		//Reset data row every search field change value.
        self.filteredRowData = []
		
		//Search in Data list.
        for data in rowData! {
            if data.provinceName.contains(textField.text!) {
                countData += 1
                self.filteredRowData?.append(data)
            } else if data.districtName.contains(textField.text!) {
                countData += 1
                self.filteredRowData?.append(data)
            }
        }
		
		//Show location searching output on console.
        print("Found: \(countData)")
        
		//Reload table new result from searching.
        self.LocationTable.reloadData()
		
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let presenter = presentingViewController as? HomeController {
            presenter.locationButton.setTitle(self.LocationTable.cellForRow(at: indexPath)?.textLabel?.text! , for: .normal)
            presenter.searchLocation = self.filteredRowData![indexPath.row]
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension LocationSelectController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.filteredRowData?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.LocationTable.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
		cell.textLabel?.textColor = UIColor(named: "BlackGray")
        if indexPath.row < self.filteredRowData?.count ?? 1 {
            cell.textLabel?.text = "\(filteredRowData![indexPath.row].provinceName) > \(filteredRowData![indexPath.row].districtName)"
        } else {
            cell.textLabel?.text = ""
        }
        return cell
    }
}

extension LocationSelectController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
}
