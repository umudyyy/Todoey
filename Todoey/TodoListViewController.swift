//
//  ViewController.swift
//  Todoey
//
//  Created by umudy on 12.01.2019.
//  Copyright © 2019 Umut Emre. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {   // ChatViewController'da bunların hepsini (UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate) eklemiştik. Burada main.storyboard'da bir View controller içine ChatViewController'deki gibi table view eklemeyip, direk TableViewController eklediğimiz için, bunun arka planını swift hallediyor ve delegate, datasource decleration'a gerek kalmıyor.
    
    let itemArray =  ["Find Mike","Buy Eggos", "Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // target yani ChatViewController classındaki  tableViewTapped metodunu seç diyoruz
        
       
    }

    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
   
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        print(itemArray[indexPath.row])
        
   
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}

