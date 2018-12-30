//
//  ItemVC.swift
//  TodoeyRealm
//
//  Created by Waleed Saad on 12/29/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import UIKit
import RealmSwift

class ItemVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private let realm = try! Realm()
    var currentCategory: Category? {
        didSet {
            loadItems()
        }
    }
    private var items: List<Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addItemAction(_ sender: UIBarButtonItem) {
        var itemTextField = UITextField()
        let addAlert = UIAlertController(title: "Add item", message: "", preferredStyle: .alert)
        addAlert.addTextField { (textField) in
            itemTextField = textField
            itemTextField.placeholder = "Add a new item"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if let itemName = itemTextField.text {
                if itemName.count > 0 {
                    if let currentCategory = self.currentCategory {
                        do {
                            try self.realm.write {
                                let newItem = Item()
                                newItem.title = itemName
                                newItem.date = Date()
                                currentCategory.items.append(newItem)
                                self.tableView.reloadData()
                            }
                        } catch {
                            debugPrint("Error saving: \(error)")
                        }
                        
                    }
                    
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
    
    
    private func loadItems(){
        items = currentCategory?.items
    }


}

extension ItemVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemCell {
            if let item = items?[indexPath.row] {
                cell.updateItemName(withItem: item)
                cell.accessoryType = item.checked ? .checkmark : .none
            }
            return cell
        }
        
        return ItemCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let item = items?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(item)
                        tableView.reloadData()
                    }
                } catch {
                    debugPrint("Error deleting item: \(error)")
                }
            }
        }
    }
}

extension ItemVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row]{
            do {
                try realm.write {
                    item.checked = !item.checked
                    tableView.reloadData()
                }
            } catch {
                
            }
        }
    }
}
