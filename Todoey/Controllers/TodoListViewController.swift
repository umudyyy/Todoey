//
//  ViewController.swift
//  Todoey
//
//  Created by umudy on 12.01.2019.
//  Copyright © 2019 Umut Emre. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {   // ChatViewController'da bunların hepsini (UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate) eklemiştik. Burada main.storyboard'da bir View controller içine ChatViewController'deki gibi table view eklemeyip, direk TableViewController eklediğimiz için, bunun arka planını swift hallediyor ve delegate, datasource decleration'a gerek kalmıyor.
    
//    var itemArray =  ["Find Mike","Buy Eggos", "Destroy Demogorgon","a","b","c","d","e","f","g","h","ı","j","k","l","m","n","o","p","k","v","y","z"]
    
    var itemArray = [Item]()
    
    
    // * Şimdiye kadar Persistent data storage olarak data "save"lemek için userdafaults ve plist (codeable protocol ile)  single tables kullandık, şimdi
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")  //userDomainMask = User's home directory,FileManager.default ta bir singleton shared.
    
//    let defaults = UserDefaults.standard  //bu da bir singleton shared.volume vs gibi şeyler kaydedilmeli bununla
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(dataFilePath)
        
//        let newItem =  Item()
//        newItem.title = "Find Mike"
//      
//        itemArray.append(newItem)
//        
//        let newItem2 =  Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//        
//        let newItem3 =  Item()
//        newItem3.title = "Destroy Demogorgon"
//        itemArray.append(newItem3)
        
        
        loadItems()
        
      
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
        // target yani ChatViewController classındaki  tableViewTapped metodunu seç diyoruz
    }

    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//      print("cellForRowAtIndexPath Called")
        
//      let cell  = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
   
        cell.textLabel?.text = item.title
        
        //Ternary operator
        cell.accessoryType = item.done ? .checkmark : .none
        
//Ternary operator kullandık yukarıda bunun yerine
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
     
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        print(itemArray[indexPath.row])
        
        
          itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
          saveItems()

//yukarıdaki line bu görevi görüyor, kaldırdık.
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
       
        
        
//Bug'a neden oluyordu, hücreye check atıp, tabloyu aşağı kaydırınca, cell reuse olduğundan aşağıdaki hücreler de seçili oluyordu. Bunu bugu burayı kaldırıp yukarıdaki kodları ekleyip, tabloyu reload yaparak aştık..
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default)
        {
            (action) in    //closure
            
//            print(textField.text!)
            
            if textField.text != "" && textField.text != nil {

              let newItem = Item()
              newItem.title = textField.text!
                
              self.itemArray.append(newItem)
                
              self.saveItems()

                //User defaults singleton ile yapmıcaz. self.itemArray bir custom Item olarak oluşturdugumuz itemlardan oluştugu için aşağıdaki kod patlar userdefaults (singleton,shared.) ile.
                //userdafaults ile custom itemlar yapamadıgımız için encoder ile yapıyoruz.
//              self.defaults.set(self.itemArray, forKey: "TodoListArray")
                
             
                
            }
//            if let text = textField.text  { //veya böyle optional binding ile yapacaksın  if let text = textField.text as? String  böylede olur.
//
//                if text.isEmpty {
//                    // Alert: textField is empty!
//                }
//
//                self.itemArray.append(text)
//
//                self.defaults.set(self.itemArray, forKey: "TodoListArray")
//
//                self.tableView.reloadData()
//            }
   
        }
        alert.addTextField { (alertTextField) in  //closure
            alertTextField.placeholder = "Create new item"  //alertTextField burada local durumda çünkü closure içinde.. (closure içinde local durumda)
            textField = alertTextField
 
        }
        
       
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
       
    }
    
    func saveItems()  {
        
        let encoder =  PropertyListEncoder()
        
        do{
            let data =  try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(){
        
        if let data =  try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
            
        }
    }
    

}

