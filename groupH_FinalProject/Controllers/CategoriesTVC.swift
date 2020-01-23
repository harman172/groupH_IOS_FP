//
//  CategoriesTVC.swift
//  groupH_FinalProject
//
//  Created by Harmanpreet Kaur on 2020-01-18.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit
import CoreData

class CategoriesTVC: UITableViewController {

    var context: NSManagedObjectContext?
    var folders: [NSManagedObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        loadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return folders?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "folderCell"){
            cell.textLabel?.text = folders![indexPath.row].value(forKey: "catname") as! String
            return cell
        }

        

        return UITableViewCell()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
    
    
    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New Folder", message: "Enter new folder", preferredStyle: .alert)
        
        alertController.addTextField { (txtNewFolder) in
            txtNewFolder.placeholder = "Enter category name..."
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        cancelAction.setValue(UIColor.brown, forKey: "titleTextColor")
        
        let addItemAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let textField = alertController.textFields![0]
            let folderName = textField.text!
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
            request.returnsObjectsAsFaults = false
            
            do{
                let results = try self.context!.fetch(request)
                
                var alreadyExists = false
                if results.count > 0{
                    for result in results as! [NSManagedObject]{
                        if folderName == result.value(forKey: "catname") as! String{
                            alreadyExists = true
                            break
                        }
                    }
                }
                
                if !alreadyExists{
                    self.addData(name: folderName)
                } else{
                    print("Folder Already exists")
                }
            }catch{
                print(error)
            }
            
            self.loadData()
            self.tableView.reloadData()
        }
        addItemAction.setValue(UIColor.black, forKey: "titleTextColor")
                
        //        alertController.view.tintColor = .black
                
        alertController.addAction(cancelAction)
        alertController.addAction(addItemAction)
                
        //        self.present(alertController, animated: false, completion: {() -> Void in
        //            alertController.view.tintColor = .black
        //        })
        self.present(alertController, animated: false, completion: nil)
    }

    func loadData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        request.returnsObjectsAsFaults = false
        
        // we find our data
        do{
            let results = try context?.fetch(request)
            
            if results is [NSManagedObject]{
                folders = results as! [NSManagedObject]
                tableView.reloadData()
            }
        } catch{
            print("Error2...\(error)")
        }
    }
    
    func addData(name: String){
        let newFolder = NSEntityDescription.insertNewObject(forEntityName: "Categories", into: context!)
        newFolder.setValue(name, forKey: "catname")
        saveData()
    }
    
    func saveData(){
        do{
           try context!.save()
        }catch{
            print(error)
        }
    }
    
    func okAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        okAction.setValue(UIColor.brown, forKey: "titleTextColor")
        
        alertController.addAction(okAction)
        self.present(alertController, animated: false, completion: nil)

    }
    
    
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
        
        if let destination = segue.destination as? NotesTVC{
            destination.categoryName = (sender as! UITableViewCell).textLabel?.text
            
        }

    }
       
}
