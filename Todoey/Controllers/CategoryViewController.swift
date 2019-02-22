//
//  CategoryViewController.swift
//  Todoey
//
//  Created by umudy on 28.01.2019.
//  Copyright © 2019 Umut Emre. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    
    let realm = try! Realm()   // do catch'e de alabiliriz. Ama hata çıkmıcak devam et diyorsun. Realm için doğru bir kullanım şekli. Çünkü genelde kaynaklar yeterli değilse vs. uygulama sadece ilk çalışmasında realm oluşturamayabilir(?)
    
//    var categories = [Category]() // CoreData,NSManaged için
    
//    var categories: Results<Category>!   // Realm için..(An implicitly unwrapped optional).Auto Obtaining container
    
     var categories: Results<Category>?    // Realm için..(An explicitly unwrapped optional) Yukarıdakini buna çevirdik. Auto Obtaining container
  
    
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  //CoreData, NSManaged
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()

    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1  // ?? --> nil coellesing operator.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //      print("cellForRowAtIndexPath Called")
        
        //      let cell  = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added yet."
        
      
        
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
            
           destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories(category: Category)  {
        
        //        let encoder =  PropertyListEncoder()
        
        //        do{
        //            let data =  try encoder.encode(itemArray)
        //            try data.write(to: dataFilePath!)
        //        } catch {
        //            print("Error encoding item array, \(error)")
        //        }
        
        do{
//            try context.save()  //NSManaged
            try realm.write {     // Realm
                realm.add(category)
            }
            
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    //func includes CoreData,NsManaged codes.
//    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest() ) {   // default value sağlıyoruz..
//
//        //        let request : NSFetchRequest<Category> = Category.fetchRequest()
//
//        do{
//            categories = try context.fetch(request)
//        } catch {
//            print("Error loading categories \(error)")
//        }
//        
//        tableView.reloadData()
//
//    }
    
    
    func loadCategories() {
        
         categories = realm.objects(Category.self)
        
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
     
//                let newCategory = Category(context: self.context)  //NSManaged
                let newCategory = Category()   //Realm
                newCategory.name = textField.text!
                
//                newItem.done = false
                
//                self.categories.append(newCategory)  CoreData,NSManaged de kullandık. Realmde buna gerek yok. var categories: Results<Category>! deki categories, self.saveCategories(category: newCategory) kodu çalıştırdıktan sonra otomatik olarak güncellenir. Results'a option ile bak, auto updating container type.
                
//                self.saveCategories()  //CoreData, NSManaged şekli
                
                self.saveCategories(category: newCategory) //  Realm şekli
          
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
