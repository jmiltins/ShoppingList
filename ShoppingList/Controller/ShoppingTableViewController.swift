//
//  ShoppingTableViewController.swift
//  ShoppingList
//
//  Created by janis.miltins on 18/11/2021.
//

import UIKit
import CoreData

class ShoppingTableViewController: UITableViewController {
    
    //var shopping = [String]()
    var shopping = [Shopping]()
    
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        // loadData()
        
    }
    
    func loadData(){
        let request: NSFetchRequest<Shopping> = Shopping.fetchRequest()
        do{
            let result = try managedObjectContext?.fetch(request)
            shopping = result!
            tableView.reloadData()
            
        }catch{
            fatalError("Error in loading core data item")
        }
    }
    
    func saveData(){
        do{
            try managedObjectContext?.save()
            
            
        }catch{
            fatalError("Error in saving in core data item")
        }
        loadData()
    }
    
    func deleteAllData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping")
        let delete: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do{
            try managedObjectContext?.execute(delete)
            saveData()
            }catch let err{
                print(err.localizedDescription)
            }
    }
    
    
    @IBAction func addNewItem(_ sender: Any) {
        
        let allertController = UIAlertController(title: "Shopping Item", message: "What do you want to add?\nHow many? ", preferredStyle: .alert)
        allertController.addTextField { textField in
            print("textFieldItem: ", textField)
        }
        //allertController.
        allertController.addTextField { textField2 in
            print("textFieldCount: ", textField2)
            //+add amount
        }
        // buttons
        //addActionButton
        let addActionButton = UIAlertAction(title: "Add", style: .default) { action in
            let textField = allertController.textFields?.first
            let entity = NSEntityDescription.entity(forEntityName: "Shopping", in: self.managedObjectContext!)
            let shop = NSManagedObject(entity: entity!, insertInto: self.managedObjectContext)
            
            shop.setValue(textField?.text, forKey: "item")
            // append in array
            //    self.shopping.append(textField!.text!)
            //reload data after adding
            self.saveData()
            self.tableView.reloadData()
            
        }
        //cancel Button
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //add two buttons
        allertController.addAction(addActionButton)
        allertController.addAction(cancelButton)
        // present buttons
        present(allertController, animated: true, completion: nil)
        
        
    }
    @IBAction func deleteAllItems(_ sender: Any) {
        let allertController = UIAlertController(title: "Delete all Shopping items?", message: "Do you want to delete them all?", preferredStyle: .actionSheet)
        let addActionButton = UIAlertAction(title: "Delete", style: .destructive) { action in
            self.deleteAllData()
        }
        //cancel Button
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //add two buttons
        allertController.addAction(addActionButton)
        allertController.addAction(cancelButton)
        // present buttons
        present(allertController, animated: true, completion: nil)
    }
    
    
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shopping.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        //cell.textLabel?.text = shopping[indexPath.row]
        let shop = shopping[indexPath.row]
        cell.textLabel?.text = shop.value(forKey: "item") as? String
        //cell.detailTextLabel?.text = "Count: "
        cell.accessoryType = shop.completed ? .checkmark : .none
        return cell
    }
    
    // MARK: - Table view deligate
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            managedObjectContext?.delete(shopping[indexPath.row])
        }
        saveData()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shopping[indexPath.row].completed = !shopping[indexPath.row].completed
        saveData()
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
