//
//  CategoryViewController.swift
//  SupersRent
//
//  Created by ivrylobs on 5/12/2562 BE.
//  Copyright © 2562 banraomaibab. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class CategoryController: UIViewController {
    
    @IBOutlet weak var CategoryTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CategoryTable.dataSource = self
        self.CategoryTable.delegate = self
    }
}


extension CategoryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.CategoryTable.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = "Hello this is cell \(indexPath.row)"
        return cell
    }
    
    
}

extension CategoryController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
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
        CategoryViewContainer()
    }
}
