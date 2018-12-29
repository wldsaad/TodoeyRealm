//
//  ViewController.swift
//  TodoeyRealm
//
//  Created by Waleed Saad on 12/29/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let realm = try! Realm()
    private var categories: Results<Category>?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadObjects()
    }

    @IBAction func addCategoryAction(_ sender: UIBarButtonItem) {
        var categoryTextField = UITextField()
        let addAlert = UIAlertController(title: "Add category", message: "", preferredStyle: .alert)
        addAlert.addTextField { (textField) in
            categoryTextField = textField
            categoryTextField.placeholder = "Add a new category"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if let categoryName = categoryTextField.text {
                if categoryName.count > 0 {
                    let newCategory = Category()
                    newCategory.name = categoryName
                    self.saveObject(object: newCategory)
                }
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            addAlert.dismiss(animated: true, completion: nil)
        }
        addAlert.addAction(addAction)
        addAlert.addAction(cancelAction)
        present(addAlert, animated: true, completion: nil)
    }
    
    private func saveObject(object: Object) {
        do {
            try self.realm.write {
                self.realm.add(object)
                self.tableView.reloadData()
            }
        } catch {
            debugPrint("Error saving: \(error)")
        }
    }
    
    private func loadObjects(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
}

extension CategoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryCell {
            if let category = categories?[indexPath.row] {
                cell.updateCategoryName(withCategory: category)
                return cell
            }
            
        }
         return CategoryCell()
    }
    
    
}
