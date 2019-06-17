//
//  ViewController.swift
//  Doit
//
//  Created by jp on 2019-06-03.
//  Copyright © 2019 Jordan Perrella. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

 var itemArray = [Item]()
 
 var selectedCategory: Category?{
  didSet{
   loadItems()
  }
 }
 
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

  override func viewDidLoad() {
    super.viewDidLoad()
   
//    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//   print("file path \(dataFilePath)")
   
   loadItems()
  }
  
  //MARK: Tableview Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    let item = itemArray[indexPath.row]
    cell.textLabel?.text = item.title
    cell.accessoryType = item.done ? .checkmark : .none
    
    return cell
  }
  
  //MARK: Tabelview Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
   itemArray[indexPath.row].done = !itemArray[indexPath.row].done
 
   saveItems()
    
   tableView.deselectRow(at: indexPath, animated: true)
  }
 
 override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
  
  let deleteAction = UIContextualAction(style: .normal, title: "Delete", handler: { (ac: UIContextualAction, view: UIView, success:(Bool) -> Void) in
   self.context.delete(self.itemArray[indexPath.row])
   self.itemArray.remove(at: indexPath.row)
   self.saveItems()
   success(true)
  })
  
  deleteAction.image = UIImage(named: "tick")
  deleteAction.backgroundColor = .red
  
  return UISwipeActionsConfiguration(actions: [deleteAction])
 }
 
  
  //MARK: Add To-Do Items
  
  @IBAction func addButtonPressed(_ sender: Any) {
    
    var textField = UITextField()
    let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
   
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
      if textField.text != ""{
      
       let newItem = Item(context: self.context)
       
       newItem.title = textField.text!
       newItem.done = false
       newItem.parentCategory = self.selectedCategory
       
       self.itemArray.append(newItem)
       
       self.saveItems()
        
      } else{
        action.isEnabled = false
      }
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "new to-do item"
      textField = alertTextField
    }
    
    alert.addAction(action)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(alert, animated: true, completion: nil)
  }
 
 
 //MARK: Data Manipulation Methods
 
 func saveItems() {
  
  do{
   try context.save()
  } catch {
   print("Error saving context \(error)")
  }
  
  self.tableView.reloadData()
 }
 
 func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
  
  let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
  
  if let additionalPredicate = predicate{
   request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
   
  }else{
   request.predicate = categoryPredicate
  }
  
  do {
   itemArray = try context.fetch(request)
  } catch{
   print("Error loading context \(error)")
  }
 }
}

extension ToDoListViewController: UISearchBarDelegate{

 func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
  
   let request : NSFetchRequest<Item> = Item.fetchRequest()
   
   let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
  
   request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
   
   loadItems(with: request, predicate: predicate)
  
  if searchBar.text?.count == 0{
   loadItems()
   DispatchQueue.main.async {
    searchBar.resignFirstResponder()
   }
  }
  tableView.reloadData()
 }
}

