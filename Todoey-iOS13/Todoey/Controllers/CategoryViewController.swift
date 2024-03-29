//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Kaala on 2022/10/07.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories:Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
        tableView.separatorStyle = .none
        
        super.categoryDelegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation Controller does not exist.")
        }
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:ContrastColorOf(UIColor(hexString: "#1d9bf6")!, returnFlat: true)]
        navBar.backgroundColor = UIColor(hexString: "#1d9bf6")
    }
    
    
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = categories?.count {
            return count != 0 ? count : 1
        } else {
            return 1
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath) // Swipe Cell
        
        if categories?.isEmpty == false, let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.backgroundColor) else { fatalError() }
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            cell.backgroundColor = categoryColor
        } else {
            cell.textLabel?.text = "No Categories Added"
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        }
        
        return cell
        
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if categories?.isEmpty == false {
            performSegue(withIdentifier: "goToItems", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // 만약 여기서 세그웨이가 여러개였다면, 조건문으로 세그웨이 id 체크 후 진행하면 된다.
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    
    //MARK: - Data Manipulation Methods
    func save(category:Category){
        do {
            try realm.write({
                realm.add(category)
            })
        } catch{
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        categories = realm.objects(Category.self)
    }
    
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if self.categories?.isEmpty == false, let categoryForDeletion = self.categories?[indexPath.row] {
            
            do {
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category: \(error)")
            }
            tableView.reloadData()
        }
    }
    
    //MARK: - Add new Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title:"Add New Todoey Category",message:"",preferredStyle: .alert)
        
        let action = UIAlertAction(title:"Add Category",style:.default){ action in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.backgroundColor = UIColor.randomFlat().hexValue()
            
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        self.present(alert,animated: true,completion: nil)
    }
    
    
    
    
}





