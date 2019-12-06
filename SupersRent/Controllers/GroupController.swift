//
//  CategoryViewController.swift
//  SupersRent
//
//  Created by ivrylobs on 5/12/2562 BE.
//  Copyright © 2562 banraomaibab. All rights reserved.
//

import UIKit
import SwiftUI

class GroupController: UIViewController {
    
    var rowData: [GroupModel]?
    
    @IBOutlet weak var CategoryTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CategoryTable.dataSource = self
        self.CategoryTable.delegate = self
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
        let cell = self.CategoryTable.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let rowLabel = rowData!
        cell.textLabel?.text = "\(rowLabel[indexPath.row].groupName)"
        return cell
    }
}

extension GroupController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let presenter = presentingViewController as? HomeController {
            presenter.CategoryButton.setTitle(self.CategoryTable.cellForRow(at: indexPath)?.textLabel?.text!, for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
