//
//  ViewController.swift
//  Doit
//
//  Created by jp on 2019-06-03.
//  Copyright © 2019 Jordan Perrella. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

  let defaults = UserDefaults.standard
  var itemArray = ["wash car", "return pants", "buy beachball", "pet a junebug"]

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let items = defaults.array(forKey: "ToDoListArray") as? [String]{
      itemArray = items
    }
    
  }
  
  //MARK: Tableview Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    cell.textLabel?.text = itemArray[indexPath.row]
    return cell
  }
  
  
  //MARK: Tabelview Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(itemArray[indexPath.row])
    
    if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
      tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }else {
      tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  //MARK: Add To-Do Items
  
  @IBAction func addButtonPressed(_ sender: Any) {
    
    var textField = UITextField()
    let alert = UIAlertController(title: "Add Item!", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      
      if textField.text != ""{
        self.itemArray.append(textField.text!)
        self.defaults.set(self.itemArray, forKey: "ToDoListArray")
        self.tableView.reloadData()
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
  
  
  
}

