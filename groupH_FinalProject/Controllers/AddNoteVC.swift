//
//  AddNoteVC.swift
//  groupH_FinalProject
//
//  Created by Harmanpreet Kaur on 2020-01-21.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit
import CoreData

class AddNoteVC: UIViewController {

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    
    var context: NSManagedObjectContext?
    var categoryName: String?


    override func viewDidLoad() {
        super.viewDidLoad()

        print(categoryName!)

        // Do any additional setup after loading the view.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")

        do{
            let results = try self.context!.fetch(request)
            
            var alreadyExists = false
            if results.count > 0{
                for result in results as! [NSManagedObject]{
                    if txtTitle.text! == result.value(forKey: "title") as! String{
                        alreadyExists = true
                        break
                    }
                }
            }
            
            if !alreadyExists{
                self.addData()
            } else{
                print("Note Already exists")
            }
        }catch{
            print(error)
        }

        
    }
    
    func addData(){
        let newNote = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: context!)
        newNote.setValue(txtTitle.text!, forKey: "title")
        newNote.setValue(txtDescription.text!, forKey: "descp")
        newNote.setValue(categoryName!, forKey: "category")
        newNote.setValue(Date(), forKey: "dateTime")
        
        saveData()
        
    }
    
    func saveData(){
        do{
           try context!.save()
        }catch{
            print(error)
        }
    }
    
    /*
    func addNotetoCatagory(note: NSManagedObject){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Folders")
        request.predicate = NSPredicate(format: "name=%@", categoryName!)
        

        do{
            
            var notesArray: [NSManagedObject]?
            var results = try context!.fetch(request) as! [NSManagedObject]
            
            if let notes = results[0].value(forKey: "notes") as? [NSManagedObject]{
                notesArray = notes
                notesArray?.append(note)
            }
            else{
                notesArray = [note]
            }
            

            
           results[0].setValue(notesArray!, forKey: "notes")
            
            
        }catch{
            print(error)
        }
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

    
    func loadData(){
           let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Folders")
           request.returnsObjectsAsFaults = false
           
           // we find our data
           do{
               let results = try context?.fetch(request)
               
               if results is [NSManagedObject]{
                   print(results)
               }
           } catch{
               print("Error2...\(error)")
           }
       }
}
