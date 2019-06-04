//
//  ViewController.swift
//  Doit
//
//  Created by jp on 2019-06-03.
//  Copyright © 2019 Jordan Perrella. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

  var itemArray = [ItemModel]()
 
   let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

  override func viewDidLoad() {
    super.viewDidLoad()
    
    print(dataFilePath)
    
    let newItem = ItemModel()
    newItem.title = "pet cat"
    itemArray.append(newItem)
    
//    if let items = defaults.array(forKey: "ToDoListArray") as? [ItemModel]{
//      itemArray = items
//    }
   
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
  
  //MARK: Add To-Do Items
  
  @IBAction func addButtonPressed(_ sender: Any) {
    
    var textField = UITextField()
    let alert = UIAlertController(title: "Add Item!", message: "", preferredStyle: .alert)
   
   let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      if textField.text != ""{
        
        let newItem = ItemModel()
        
        newItem.title = textField.text!
        
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
  
  let encoder = PropertyListEncoder()
  
  do{
   let data = try encoder.encode(itemArray)
   try data.write(to: dataFilePath!)
  } catch {
   print("Error encoding item array, \(error)")
  }
  
  self.tableView.reloadData()
 }
 
 
 func loadItems(){
  if let data = try? Data(contentsOf: dataFilePath!){
   let decoder = PropertyListDecoder()
   do {
    itemArray = try decoder.decode([ItemModel].self, from: data)
   } catch {
    print("Error decoding item array, \(error)")
   }
  }
  
 }
  
  
}

