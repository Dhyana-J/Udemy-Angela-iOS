//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift


// Problem need to solve! : 상위 카테고리가 지워지면 하위 아이템들도 지워지도록 하는 작업 필요. 상위 카테고리 지우면 고아가 됨. UI상으로 지울 수 있는 방법이 없다.

class ToDoListViewController: SwipeTableViewController {
    
    var todoListItems:Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory:Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.toDoListDelegate = self
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        if let count = todoListItems?.count {
            return count != 0 ? count : 1
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#function)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if todoListItems?.isEmpty == false, let item = todoListItems?[indexPath.row]{
            cell.textLabel?.text = item.title // iOS 14부턴 contentConfiguration 사용해야
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        }
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if todoListItems?.isEmpty == false, let item = todoListItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done // UPDATE METHOD
//                    realm.delete(item) // DELETE METHOD
                }
            } catch {
                print("Error saving done status : \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Data Manipulation Methods
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title:"Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //what will happen once the user clicks the Add item button on our UIAlert
            
            // ----- Lecture 263.Challenge 여기에 Realm을 통한 아이템 추가 메서드 구현하기.
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        //            self.save(item: newItem) // 필요없다. Category처럼 realm.add로 하는게 아니라, category와 linking되어있으므로, 그냥 append를 통해 추가가 가능하다.
                    }
                } catch {
                    print("Error saving context \(error)")
                }
            }
            
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func loadItems(){
        todoListItems = selectedCategory?.items.sorted(byKeyPath: "title",ascending: true) // 알파벳 순서로 정렬
        tableView.reloadData()
    }
    
    
    override func updateModel(at indexPath: IndexPath) {
        if self.todoListItems?.isEmpty == false, let todoListItemForDeletion = self.todoListItems?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(todoListItemForDeletion)
                }
            } catch {
                print("Error deleting category: \(error)")
            }
            tableView.reloadData()
        }
    }
    
    
}


//MARK: - Search Bar Methods
extension ToDoListViewController:UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoListItems = selectedCategory?.items.filter(NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)).sorted(byKeyPath: "dateCreated", ascending:false) // 가장 최근 날짜일수록 가장 큰값이라 descending하면 최근날짜가 위에옴
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function)
        if searchBar.text!.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }

}

