//
//  ViewController.swift
//  TodoeyRealm
//
//  Created by Waleed Saad on 12/29/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noCategoriesView: UIView!
    private let realm = try! Realm()
    private var categories: Results<Category>?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadObjects()
        showHideViews()
    }

    private func showHideViews(){
        if let categoriesCount = categories?.count {
            noCategoriesView.isHidden = categoriesCount > 0 ? true : false
            tableView.isHidden = categoriesCount > 0 ? false : true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.flatBlack
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.flatBlack]
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
                    newCategory.color = UIColor.randomFlat.hexValue()
                    self.saveObject(object: newCategory)
                    self.showHideViews()
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let category = categories?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(category)
                        showHideViews()
                        tableView.reloadData()
                    }
                } catch {
                    debugPrint("Error removing category: \(error)")
                }
            }
        }
    }
    
}

extension CategoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedCategory = categories?[indexPath.row] {
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "itemsSegue", sender: selectedCategory)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let itemsVC = segue.destination as? ItemVC {
            itemsVC.currentCategory = (sender as! Category)
        }
    }
}
