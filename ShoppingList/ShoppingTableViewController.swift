//
//  ShoppingTableViewController.swift
//  ShoppingList
//
//  Created by Kisacka on 09/09/2020.
//  Copyright © 2020 Kisacka. All rights reserved.
//

import UIKit
import CoreData

class ShoppingTableViewController: UITableViewController {
    
    var groseries = [Grocery]()
    
    //  var gros = [String]()
    
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
  //      loadData()
        //this is for Liya app, to see the way
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    @IBAction func addNewItemTapped(_ sender: Any) {
        pickNewGrocery()
    }
    
    
    func pickNewGrocery(){
        //alert window
        let alertController = UIAlertController(title: "Grosery Item!", message: "What do you want to buy?", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField) in
            //Text below will be shown in the field, where to write item
            textField.placeholder = "Enter the title of your task"
            //The first letter of the item will automatically turn to Big letter - Tea, Sugar
            textField.autocapitalizationType = .sentences
        }
        //add button
        let addAction = UIAlertAction(title: "Add", style: .cancel) { (action: UIAlertAction) in
            
            
            let textField = alertController.textFields?.first
            
            
            let entity = NSEntityDescription.entity(forEntityName: "Grocery", in: self.context!)
            let grocery = NSManagedObject(entity: entity!, insertInto: self.context)
            grocery.setValue(textField?.text, forKey: "item")
            
      //      self.groseries.append(grocery as! Grocery)
            self.saveData()

            
        }
        //end addAction
        
        //cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    //MARK:-Func for CoreData - save, load
    //#warning some trouble there - if uncomented, then it shows up as yellow
    
    //to reload table view
    func loadData(){
        let request: NSFetchRequest<Grocery> = Grocery.fetchRequest()
        do{
            let result = try context?.fetch(request)
            groseries = result!
            
        } catch {
            fatalError(error.localizedDescription)
        }
        tableView.reloadData()
        
    }
    

    
    func saveData(){
        do {
            //saving grocery item
            try self.context?.save()            }
        catch{
            fatalError(error.localizedDescription)
        }
        self.loadData()
    }
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groseries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell", for: indexPath)
        
        //   cell.textLabel!.text = gros[indexPath.row]
        let grocery = groseries[indexPath.row]
        cell.textLabel?.text = grocery.value(forKey: "item") as? String
        
        cell.selectionStyle = .none
        
        //check mark
        cell.accessoryType = grocery.completed ? .checkmark : .none
        
        
        return cell
    }
    
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //Homework - adding Delete Warning
            let alert = UIAlertController(title: "Delete?", message: "Are you sure you want to delete?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (_) in
                let item = self.groseries[indexPath.row]
    
                
                self.context?.delete(item)
      //          tableView.reloadRows(at: [indexPath], with: .automatic)
                self.saveData()
                

            }))
            self.present(alert, animated: true )
            
            //2 rows below was the code before adding Delete Alert Warning
            //    managedObjectContext?.delete(groseries[indexPath.row])
            //tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        saveData()
        //        do {
        //            //saving what was deleted
        //            try self.managedObjectContext?.save()            }
        //        catch{
        //            fatalError("Error to deleting Grocery item")
        //        }
        //        loadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        groseries[indexPath.row].completed = !groseries[indexPath.row].completed
        
        saveData()
        //        do {
        //            //saving check mark ??
        //            try self.managedObjectContext?.save()            }
        //        catch{
        //            fatalError("Error to checkmark Grocery item")
        //        }
        //        loadData()
    }
    
    // animation on clicking
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.9) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    /*
     //Homework function
     func savingChanges(message: String) {
     do {
     try self.context?.save()            }
     catch{
     fatalError(message)
     }
     
     // loadData()
     tableView.reloadData()
     
     }
     */
    
    
}
