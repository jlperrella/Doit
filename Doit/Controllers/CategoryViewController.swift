//
//  CategoryViewController.swift
//  Doit
//
//  Created by jp on 2019-06-11.
//  Copyright © 2019 Jordan Perrella. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {
  
  var categoryArray = [Category]()
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
      loadCategories()

    }
  
  //MARK: - TableView DataSource
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoryArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    cell.textLabel?.text = categoryArray[indexPath.row].name
    
    return cell
  }
  
  
  //MARK: - Data Manipulation
  
  func saveCategories(){
    do {
      try context.save()
    } catch {
      print("error saving categories \(error)")
    }
    loadCategories()
  }
  
  func loadCategories() {
    let request: NSFetchRequest<Category> = Category.fetchRequest()
    
    do {
      categoryArray = try context.fetch(request)
    }catch{
      print ("error loading categories \(error)")
    }
    tableView.reloadData()
  }
  
  
  //MARK: - Add New Categories
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "Add", style: .default) { (action) in
      
      if textField.text != "" {
        let newCategory = Category(context: self.context)
        newCategory.name = textField.text!
        self.categoryArray.append(newCategory)
        self.saveCategories()
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
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let deleteAction = UIContextualAction(style: .normal, title: "Delete", handler: { (ac: UIContextualAction, view: UIView, success:@escaping (Bool) -> Void) in
      
      let deleteAlert = UIAlertController(title: "Delete Category", message: "Deleting this category also deletes it's assocaited items", preferredStyle: .alert)
      
      let deleteAlertAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
        self.context.delete(self.categoryArray[indexPath.row])
        self.categoryArray.remove(at: indexPath.row)
        self.saveCategories()
        success(true)
      })
      
      deleteAlert.addAction(deleteAlertAction)
      deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      
      self.present(deleteAlert, animated: true, completion: nil)
      
    })
  
    deleteAction.backgroundColor = .red
    
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }

  
  //MARK: - TableView Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "ItemView", sender: self)
    tableView.deselectRow(at: indexPath, animated: true)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! ToDoListViewController
    
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedCategory = categoryArray[indexPath.row]
    }
  }
  

  
  
}

