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
        
        print(indexPath.row)
        
        if let presenter = presentingViewController as? HomeController {
            presenter.CategoryButton.titleLabel?.text = self.CategoryTable.cellForRow(at: indexPath)?.textLabel?.text
        }
        
        dismiss(animated: true, completion: nil)
    }
}


struct CategoryViewContainer: UIViewControllerRepresentable { 
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CategoryViewContainer>) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "Category")
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CategoryViewContainer>) {
        
    }
}

struct CategoryController_Previews: PreviewProvider {
    static var previews: some View {
        CategoryViewContainer().previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
}
