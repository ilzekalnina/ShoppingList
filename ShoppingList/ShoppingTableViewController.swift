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
    
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        loadData()
        
    }
    
    @IBAction func addNewItemTapped(_ sender: Any) {
        pickNewGrocery()
    }
    
    
    func pickNewGrocery(){
        //alert window
        let alertController = UIAlertController(title: "Grosery Item!", message: "What do you want to buy?", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField) in
        }
        //add button
        let addAction = UIAlertAction(title: "Add", style: .cancel) { (action: UIAlertAction) in
            
            let textField = alertController.textFields?.first
            //            self.gros.append(textField!.text!)
            //            self.tableView.reloadData()
            let entity = NSEntityDescription.entity(forEntityName: "Grocery", in: self.managedObjectContext!)
            let grocery = NSManagedObject(entity: entity!, insertInto: self.managedObjectContext)
            grocery.setValue(textField?.text, forKey: "item")
            
            
            self.savingChanges(message: "Error to store Grocery item")
            //            do {
            //                //saving grocery item
            //                try self.managedObjectContext?.save()            }
            //            catch{
            //                fatalError("Error to store Grocery item")
            //            }
            //            self.loadData()
            
        }
        //end addAction
        //cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    //to reload table view
    func loadData(){
        let request: NSFetchRequest<Grocery> = Grocery.fetchRequest()
        do{
            let result = try managedObjectContext?.fetch(request)
            groseries = result!
            tableView.reloadData()
        } catch {
            fatalError("Error in retrieving Grocery items")
        }
        
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
            let alert = UIAlertController(title: "Are you sure you want to delete?", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (_) in
                self.managedObjectContext?.delete(self.groseries[indexPath.row])
                UIView.transition(with: tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }, completion: nil)
            }))
            self.present(alert, animated: true )
            
            //2 rows below was the code before adding Delete Alert Warning
            //    managedObjectContext?.delete(groseries[indexPath.row])
            //tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        savingChanges(message: "Error to deleting Grocery item")
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
        
        savingChanges(message: "Error to checkmark Grocery item")
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
    
    //Homework function
    func savingChanges(message: String) {
        do {
            try self.managedObjectContext?.save()            }
        catch{
            fatalError(message)
        }
        loadData()
    }
    
    
}
