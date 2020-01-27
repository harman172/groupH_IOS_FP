//
//  NotesCell.swift
//  groupH_FinalProject
//
//  Created by Harmanpreet Kaur on 2020-01-22.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class NotesCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(note: NSManagedObject){
        labelTitle.text = note.value(forKey: "title") as! String
        
        //get date
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormat.string(from: note.value(forKey: "dateTime") as! Date)
        labelDate.text = formattedDate

        //get time
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH:MM:SS"
        let formattedTime = timeFormat.string(from: note.value(forKey: "dateTime") as! Date)
        labelTime.text = formattedTime
        
        getAddress(lat: note.value(forKey: "lat") as! Double, long: note.value(forKey: "long") as! Double)
    }
    
    func getAddress(lat: Double, long: Double){
        var address = ""
        print("...address...")
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: lat, longitude: long)) { (placemarks, error) in
            if let error = error{
                print(error)
                
            } else{
                
                if let placemark = placemarks?[0]{
                    if placemark.locality != nil{
                        address += placemark.locality!
                    }
                }
                if let placemark = placemarks?[0]{
                    if placemark.subAdministrativeArea != nil{                        address += ", \(placemark.subAdministrativeArea!), "
                    }
                }
                if let placemark = placemarks?[0]{
                    if placemark.administrativeArea != nil{
                        address += placemark.administrativeArea!
                    }
                }
//                if let placemark = placemarks?[0]{
//                    if placemark.country != nil{
//                        print(placemark.country!)
//                        address += placemark.country!
//                    }
//                }
                self.labelLocation.text = address
            }
        }
    }

}
