//
//  NotesCell.swift
//  groupH_FinalProject
//
//  Created by Harmanpreet Kaur on 2020-01-22.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit
import CoreData

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
        
    }

}
