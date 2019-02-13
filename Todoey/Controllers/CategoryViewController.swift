//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Faiz Mohideen on 08/02/2019.
//  Copyright © 2019 Faiz Mohideen. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    var realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }
    
    @IBAction func addCategory(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let category = Category()
            category.name = textField.text!
            category.cellColour = UIColor.randomFlat.hexValue()
            self.save(category: category)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added!"
        
        guard let categoryColour = UIColor(hexString: categories?[indexPath.row].cellColour ?? "FFFFF") else { fatalError() }
        cell.backgroundColor = categoryColour
        cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let todoVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            todoVC.selectedCategory = self.categories?[indexPath.row]
        }
    }
    
    func save(category: Category) {
        do {
            try self.realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategory() {
        categories = realm.objects(Category.self)
        self.tableView.reloadData()
    }
    
    override func updateCell(indexPath: IndexPath) {
        //         handle action by updating model with deletion

        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting data, \(error)")
            }
        }
    }
}
