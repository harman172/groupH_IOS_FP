//
//  AddNoteVC.swift
//  groupH_FinalProject
//
//  Created by Harmanpreet Kaur on 2020-01-21.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit
import CoreData

class AddNoteVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    
    @IBOutlet weak var noteImageView: UIImageView!
    
    
    var context: NSManagedObjectContext?
    var categoryName: String?

    var isNewNote = true
    var noteTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        if !isNewNote{
            
            showClickedNoteData(noteTitle!)
            // show all data to user
            
            
        }
        //txtTitle.text = ""
        
        noteImageView.image = UIImage(contentsOfFile: getImageFilePath())
        print(categoryName!)

        // Do any additional setup after loading the view.
        
        var tapG = UITapGestureRecognizer(target: self, action: #selector(choosePhoto))
        
        noteImageView.addGestureRecognizer(tapG)
        
        
    }
    
    func showClickedNoteData(_ title: String){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        request.predicate = NSPredicate(format: "title = %@", title)
        
        do{
            let results = try context!.fetch(request)
            let noteData = results[0] as! NSManagedObject
            
            txtTitle.text = noteData.value(forKey: "title") as! String
            txtDescription.text = noteData.value(forKey: "descp") as! String
            
            let imagePath = noteData.value(forKey: "image") as! String
            
            noteImageView.image = UIImage(contentsOfFile: imagePath)
            
        }catch{
            print("unable to fech note-data")
        }
        
        
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
        
        
        // save image to file
        saveImageToFile()
        
        newNote.setValue(getImageFilePath(), forKey: "image")
        
        saveData()
        print("note saved successfullys")
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
    // MARK: - file functions
    func getImageFilePath()->String{
           
           let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
           
           
           if documentPath.count > 0 {
               
               let documentDirectory = documentPath[0]
               
            let filePath = documentDirectory.appending("\(txtTitle.text)_img.txt")
               
               return filePath
               
           }
           
           
           return ""
       }
    
    
    
    func saveImageToFile(){
        
        let myimage = noteImageView.image
        
        let imageData = myimage?.pngData()
        
        let url = URL(fileURLWithPath: getImageFilePath())
        
        // write to path
        do{
            try noteImageView.image?.pngData()!.write(to: url)
            
            
            
                //.write(toFile: filePath, atomically: true, encoding: .utf8)
        }catch{
            print(error)
        }
        
    }
    // MARK: - Image functions
    
    @objc func choosePhoto(){
        
        
        
        let imagePicker = UIImagePickerController()
               imagePicker.delegate = self
               
               let action = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
               
               action.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
                   
                   if UIImagePickerController.isSourceTypeAvailable(.camera){
                       imagePicker.sourceType = .camera
                       self.present(imagePicker, animated: true, completion: nil)
                   }
                   else{
                       self.notAvailable()
                   }
                  
                   
                   
               }))
               action.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (action:UIAlertAction) in
                   imagePicker.sourceType = .photoLibrary
                        
                   self.present(imagePicker, animated: true, completion: nil)
                         
                         
                     }))
               action.addAction(UIAlertAction(title: "cancel", style:.cancel, handler: nil ))
               
               self.present(action, animated: true, completion: nil)
             
               
        
        
    }
    
    
   
        

    
    func notAvailable(){
        
        let action = UIAlertController(title: "Camera not available", message: "", preferredStyle: .alert)
        
        action.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(action, animated: true, completion: nil)
        
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        // new note
        noteImageView.image = image
        
        //old note
        
        
    
        
        picker.dismiss(animated: true, completion: nil)
        
        saveImageToFile()
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
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
