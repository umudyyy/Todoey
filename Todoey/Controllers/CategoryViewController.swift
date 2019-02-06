//
//  CategoryViewController.swift
//  Todoey
//
//  Created by umudy on 28.01.2019.
//  Copyright © 2019 Umut Emre. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()

    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //      print("cellForRowAtIndexPath Called")
        
        //      let cell  = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        //Ternary operator
//        cell.accessoryType = item.done ? .checkmark : .none
        
        //Ternary operator kullandık yukarıda bunun yerine
        //        if item.done == true {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        
        return cell
    }

    
    //MARK: - TableView Delegate Methods
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Eğer cate. controllerden çıkan birden fazla segue olsaydı burada if stat. kullanırdık.
        // if segue with identifiers = "goToItems" then do this.
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {  //indexPathForSelectedRow optional old.için opt.binding yaptık.indexPathForSelectedRow?.xxxx demek gerekseydi unwrap etmek, ? koymak gerekirdi.
            
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories()  {
        
        //        let encoder =  PropertyListEncoder()
        
        //        do{
        //            let data =  try encoder.encode(itemArray)
        //            try data.write(to: dataFilePath!)
        //        } catch {
        //            print("Error encoding item array, \(error)")
        //        }
        
        do{
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest() ) {   // default value sağlıyoruz..
        
        //        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            categories = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default)
        {
            (action) in    //closure
            
            //            print(textField.te xt!)
            
            if textField.text != "" && textField.text != nil {
     
                let newCategory = Category(context: self.context)
                
                newCategory.name = textField.text!
                
//                newItem.done = false
                
                self.categories.append(newCategory)
                
                self.saveCategories()
          
            }
        
        }
        alert.addTextField { (alertTextField) in  //closure
            alertTextField.placeholder = "Add a new category"  //alertTextField burada local durumda çünkü closure içinde.. (closure içinde local durumda)
            textField = alertTextField
        }
     
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

    
  
    


    
  
    
}
