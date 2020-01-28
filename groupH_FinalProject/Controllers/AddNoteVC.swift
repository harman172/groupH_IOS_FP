//
//  AddNoteVC.swift
//  groupH_FinalProject
//
//  Created by Harmanpreet Kaur on 2020-01-21.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import CoreLocation




class AddNoteVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate , AVAudioRecorderDelegate{

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var txtDescription: UITextView!
    
    @IBOutlet weak var icMap: UIBarButtonItem!
    @IBOutlet weak var catagoryTextField: UITextField!
    @IBOutlet weak var noteImageView: UIImageView!
    
    var newNote: NSManagedObject?
    
    var isPlaying = false
    var isRecording = false
    var recordingSession: AVAudioSession!
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    var records = 0
    
    var context: NSManagedObjectContext?
    
    var categoryName: String?
    var isNewNote = true
    var noteTitle: String?

    var locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        catagoryTextField.text = categoryName!
        recordButton.layer.cornerRadius = 30
        playButton.layer.cornerRadius = 30
        txtDescription.delegate = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        if !isNewNote{
            playButton.isHidden = false
            showClickedNoteData(noteTitle!)
            // show all data to user
            
            recordingSession = AVAudioSession.sharedInstance()
            icMap.isEnabled = true
            navigationItem.title = "Edit note"
        }else{
            playButton.isHidden = true
            icMap.isEnabled = false
        }
        

        // Do any additional setup after loading the view.
        
        let tapG = UITapGestureRecognizer(target: self, action: #selector(choosePhoto))
        noteImageView.addGestureRecognizer(tapG)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = manager.location!.coordinate
    }
    
    func showClickedNoteData(_ title: String){
        
        txtTitle.isEnabled = false
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        request.predicate = NSPredicate(format: "title = %@", title)
        
        do{
            let results = try context!.fetch(request)
            newNote = results[0] as! NSManagedObject
            
            txtTitle.text = newNote!.value(forKey: "title") as! String
            txtDescription.text = newNote!.value(forKey: "descp") as! String
            
            //let imagePath = noteData.value(forKey: "image") as! String
            print("\(newNote!.value(forKey: "lat") as! Double)")
            noteImageView.image = UIImage(contentsOfFile: getFilePath("\(txtTitle.text)_img.txt"))
            
        }catch{
            print("unable to fech note-data")
        }
        
        
    }
    
    //MARK: Record and Play audio
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        print("1")
        
        if !isRecording {
            playButton.isHidden = true
            recordButton.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            
            if audioRecorder == nil {
                       print("3")
                       //self.records += 1
                   
                let url = URL(fileURLWithPath: getFilePath("\(txtTitle.text)_aud.m4a"))
                       let settings = [AVFormatIDKey : kAudioFormatAppleLossless , AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue , AVEncoderBitRateKey : 320000 , AVNumberOfChannelsKey : 1 , AVSampleRateKey : 44100] as [String : Any]
                       
                       do {
                        print("4")
                         audioRecorder = try AVAudioRecorder(url: url, settings: settings)
                           audioRecorder?.delegate = self
                           audioRecorder?.record()
                        isRecording = true
                       } catch  {
                        print("4 - error")
                           print(error)
                       }
                     
                   }
            
        }
        
        else{
            
            print("stop called")
            audioRecorder?.stop()
            audioRecorder = nil
            recordButton.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            isRecording = false
            playButton.isHidden = false
        }
     
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        print("play btn detected")
        
        if !isPlaying{
        
        do {
            
            let url = URL(fileURLWithPath: getFilePath("\(txtTitle.text)_aud.m4a"))
            print("playing")
            audioPlayer =  try AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
            audioPlayer.play()
            playButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            isPlaying = true
        } catch  {
            
            print("error in playing")
            print(error)
            }
        }else{
            
            audioPlayer.stop()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            isPlaying = false
            
            }
      
        
    }
    
    // MARK: AudioPlayer finish Playing
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
       playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        
        
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        
        if isNewNote{
            
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
                
                if !alreadyExists {
                    
                    if (txtTitle.text!.isEmpty || txtDescription.text.isEmpty || catagoryTextField.text!.isEmpty){// empty field}
                    
                       okAlert("Please fill all the details")
                    
                    }else{
                        self.addData()
                        isNewNote = false
                    }
                    
                } else{
                    print("Note Already exists")
                    isNewNote = true
                }
            }catch{
                print(error)
            }
            
        }else{
            
            addData()
            
        }
    }
    
    func addData(){
        
        if isNewNote{
        newNote = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: context!)
            
        }
        
        newNote!.setValue(txtTitle.text!, forKey: "title")
        newNote!.setValue(txtDescription.text!, forKey: "descp")
        newNote!.setValue(categoryName!, forKey: "category")
        let createdDate =  isNewNote ? Date() : (newNote?.value(forKey: "dateTime")! as! Date)
        newNote!.setValue(createdDate, forKey: "dateTime")
        newNote!.setValue(catagoryTextField.text!, forKey: "category")
        let lat = isNewNote ? currentLocation.latitude : newNote?.value(forKey: "lat") as! Double
        newNote?.setValue(lat, forKey: "lat")
        let long = isNewNote ? currentLocation.longitude : newNote?.value(forKey: "long") as! Double
        newNote?.setValue(long, forKey: "long")
        
        updateCatagoryList()
        // save image to file
        saveImageToFile()
        
       
        
        saveData()
        
        
        okAlert(isNewNote ? "Note Saved" : "Note Updated")
//        self.navigationController?.popViewController(animated: true)
    }
    
    
    func okAlert(_ msg: String){
        
        let AC = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
//        AC.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        AC.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
        self.present(AC, animated: true)
        
    }
    
    func saveData(){
        do{
           try context!.save()
        }catch{
            print(error)
        }
    }
    
    
    
    
    func updateCatagoryList(){
        
        var catagoryPresent = false
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        request.returnsObjectsAsFaults = false
        
        // we find our data
        do{
            let results = try context?.fetch(request) as! [NSManagedObject]
            
            for r in results{
                
                if catagoryTextField.text! == (r.value(forKey: "catname") as! String) {
                    catagoryPresent = true;
                    break
                    
                }
                
            }
            
            
            
        } catch{
            print("Error2...\(error)")
        }
        
        
        if !catagoryPresent{
            
            let newFolder = NSEntityDescription.insertNewObject(forEntityName: "Categories", into: context!)
                   newFolder.setValue(catagoryTextField.text!, forKey: "catname")
                   saveData()
            
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
    func getFilePath(_ fileName: String)->String{
           
           let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
           
        
           if documentPath.count > 0 {
               
               let documentDirectory = documentPath[0]
               
            let filePath = documentDirectory.appending(fileName)
               
               return filePath
               
           }
           return ""
       }
    
    
    
    func saveImageToFile(){
        
        let myimage = noteImageView.image
        
        let imageData = myimage?.pngData()
        
        let url = URL(fileURLWithPath: getFilePath("\(txtTitle.text)_img.txt"))
        
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
    
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? MapVC{
            dest.segueLatitude = newNote?.value(forKey: "lat") as! Double
            dest.segueLongitude = newNote?.value(forKey: "long") as! Double
            
            
            
            
        }
    }
   


}
extension AddNoteVC: UITextViewDelegate , AVAudioPlayerDelegate {
    
    
   func textViewDidBeginEditing(_ textView: UITextView) {
    if txtDescription.text == "Write note...."{
         txtDescription.text = ""
    }
       
    txtDescription.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isToolbarHidden = false
    }
    
    
    
    
    
}
