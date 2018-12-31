//
//  ItemVC.swift
//  TodoeyRealm
//
//  Created by Waleed Saad on 12/29/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ItemVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private let realm = try! Realm()
    var currentCategory: Category? {
        didSet {
            loadItems()
        }
    }
    private var items: Results<Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.barTintColor = UIColor.init(hexString: currentCategory?.color ?? UIColor.flatGray.hexValue())

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
                        let newItem = Item()
                        newItem.title = itemName
                        newItem.date = Date()
                        do {
                            try self.realm.write {
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
        items = currentCategory?.items.sorted(byKeyPath: "date", ascending: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavColors()

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        restoreColors()
    }
    
    private func restoreColors(){
        navigationController?.navigationBar.barTintColor = UIColor.flatWhite
        navigationController?.navigationBar.tintColor = UIColor.flatBlack
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.flatBlack]

    }
    
    private func updateNavColors(){
        guard let categoryColor = UIColor.init(hexString: currentCategory?.color ?? UIColor.flatWhite.hexValue()) else {
            return
        }
        navigationController?.navigationBar.barTintColor = categoryColor
        navigationController?.navigationBar.tintColor = UIColor.init(contrastingBlackOrWhiteColorOn: categoryColor, isFlat: true)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(contrastingBlackOrWhiteColorOn: categoryColor, isFlat: true)]
        title = currentCategory?.name
        
    }

}

extension ItemVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemCell {
            if let item = items?[indexPath.row] {
                cell.updateItem(withItem: item, currentCellNumber: indexPath.row, totalItemsNumber: (items?.count)!, color: currentCategory?.color ?? UIColor.flatWhite.hexValue())
                cell.accessoryType = item.checked ? .checkmark : .none

            }
            if let categoryBackgroundColor = currentCategory?.color {
                let percentage = CGFloat(indexPath.row) / CGFloat(items?.count ?? 0)
                cell.backgroundColor = UIColor.init(hexString: categoryBackgroundColor)?.darken(byPercentage: percentage)
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

extension ItemVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            tableView.reloadData()
        } else {
            items = currentCategory?.items.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "date", ascending: false)
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
