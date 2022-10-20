//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

/*
 CHALLENGE!!
 
 item load request와 search load request에 카테고리 적용하는거 해결하자
 */

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory:Category? {
        didSet {
            loadItems()
        }
    }
    
    //    let defaults = UserDefaults.standard
    /* UserDefaults 사용하는 경우
     * 규모가 아주 작은 데이터를 저장하는데 적합하다. [ ex)volume status(on,off,high,low), top score, player nickname, etc.. ]
     * plist파일 전부를 불러와야하므로, 데이터가 커지면 점점 부담이 커짐
     */
    
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //        if let items = defaults.array(forKey: "TodoListArray") as? [Item] { // UserDefaults 관련 코드
        //            itemArray = items
        //        }
        
    }
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell",for:indexPath)
        
        cell.textLabel?.text = item.title // iOS 14부턴 contentConfiguration 사용해야
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        context.delete(itemArray[indexPath.row]) //context delete method
        //        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title:"Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //what will happen once the user clicks the Add item button on our UIAlert
            print("Add Item Pressed")
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory //datamodel relationship
            
            self.itemArray.append(newItem)
            
            //self.defaults.set(self.itemArray, forKey: "TodoListArray") // UserDefaults 관련 코드
            
            self.saveItems()
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate? = nil){ //default value
        do {
            let categoryPredicate = NSPredicate(format:"parentCategory == %@", selectedCategory!)
            //            request.predicate = NSPredicate(format:"parentCategory.name MATCHES %@", selectedCategory!.name!) // 이것도 가능
            
            if let additionalPredicate = predicate {
                request.predicate = NSCompoundPredicate(type: .and, subpredicates: [additionalPredicate, categoryPredicate])
            } else {
                request.predicate = categoryPredicate
            }
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            itemArray = try context.fetch(request)
            
        } catch{
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    
}


//MARK: - Search Bar Methods
extension ToDoListViewController:UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let searchPredicate = NSPredicate(format:"title CONTAINS[cd] %@", searchBar.text!)
        loadItems(with: request, predicate: searchPredicate)
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

