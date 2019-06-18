//
//  CategoryViewController.swift
//  Doit
//
//  Created by jp on 2019-06-11.
//  Copyright © 2019 Jordan Perrella. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit


class CategoryViewController: UITableViewController {
  
  let realm = try! Realm()
  var categories: Results<Category>?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.rowHeight = 60.0
      loadCategories()

    }
  
  //MARK: - TableView DataSource
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories?.count ?? 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
    cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
    
    cell.delegate = self
    
    return cell
  }

  
  //MARK: - Data Manipulation
  
  func save(category: Category){
    do {
      try realm.write {
          realm.add(category)
      }
    } catch {
      print("error saving categories \(error)")
    }
    loadCategories()
  }
  
  func loadCategories() {
    
    categories = realm.objects(Category.self)
    
    tableView.reloadData()
    
  }
  
  
  //MARK: - Add New Categories
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "Add", style: .default) { (action) in
      
      if textField.text != "" {
        
        let newCategory = Category()
        newCategory.name = textField.text!
        self.save(category: newCategory)
      
      } else {
        action.isEnabled = false
      }
    }
    
      alert.addTextField{ (alertTextField) in
        alertTextField.placeholder = "New category"
        textField = alertTextField
      }
      
      alert.addAction(alertAction)
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      present(alert, animated: true, completion: nil)
  }
  
  
  
 
  
  
  
  //MARK: - Swipe To Delete
//  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//    
//    let deleteAction = UIContextualAction(style: .normal, title: "Delete", handler: { (ac: UIContextualAction, view: UIView, success:@escaping (Bool) -> Void) in
//      
//      let deleteAlert = UIAlertController(title: "Delete Category", message: "Deleting this category also deletes it's assocaited items", preferredStyle: .alert)
//      
//      let deleteAlertAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
//        self.context.delete(self.categoryArray[indexPath.row])
//        self.categoryArray.remove(at: indexPath.row)
//        self.saveCategories()
//        success(true)
//      })
//      
//      deleteAlert.addAction(deleteAlertAction)
//      deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//      
//      self.present(deleteAlert, animated: true, completion: nil)
//      
//    })
//  
//    deleteAction.backgroundColor = .red
//    
//    return UISwipeActionsConfiguration(actions: [deleteAction])
//  }

  
  //MARK: - TableView Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "ItemView", sender: self)
    tableView.deselectRow(at: indexPath, animated: true)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! ToDoListViewController
    
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedCategory = categories?[indexPath.row]
    }
  }
}

extension CategoryViewController: SwipeTableViewCellDelegate{
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else { return nil }
    
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
      
      if let categoryForDeletion = self.categories?[indexPath.row]{
        do{
          try self.realm.write {
            self.realm.delete(categoryForDeletion)
          }
        } catch{
          print(error)
        }
      }
    }
    
    // customize the action appearance
    deleteAction.image = UIImage(named: "Trash-Icon")
    
    return [deleteAction]
  }
  
  func tableView(_ collectionView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
    var options = SwipeOptions()
    options.expansionStyle = .destructive
    return options
  }
  
}

