//
//  LocationController.swift
//  SupersRent
//
//  Created by ivrylobs on 5/12/2562 BE.
//  Copyright © 2562 banraomaibab. All rights reserved.
//

import UIKit
import SwiftUI

class LocationController: UIViewController {
    
    var rowData: [LocationModel]?
    var filteredRowData: [LocationModel]?
    
    @IBOutlet weak var LocationTable: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.LocationTable.delegate = self
        self.LocationTable.dataSource = self
        self.searchTextField.delegate = self
        
        filteredRowData = rowData
    }
    
    @IBAction func BackToHomeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var countData = 0
        self.filteredRowData = []
        for data in rowData! {
            if data.provinceName.contains(textField.text!) {
                countData += 1
                self.filteredRowData?.append(data)
            } else if data.districtName.contains(textField.text!) {
                countData += 1
                self.filteredRowData?.append(data)
            } else {
                print("Not Found")
            }
        }
        print(countData)
        
        self.LocationTable.reloadData()
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let presenter = presentingViewController as? HomeController {
            presenter.LocationButton.setTitle(self.LocationTable.cellForRow(at: indexPath)?.textLabel?.text! , for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension LocationController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRowData?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.LocationTable.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        if indexPath.row < self.filteredRowData?.count ?? 1 {
            cell.textLabel?.text = "\(filteredRowData![indexPath.row].provinceName) > \(filteredRowData![indexPath.row].districtName)"
        } else {
            cell.textLabel?.text = ""
        }
        return cell
    }
}

extension LocationController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
}
