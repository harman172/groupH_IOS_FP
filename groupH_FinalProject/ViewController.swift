//
//  ViewController.swift
//  groupH_FinalProject
//
//  Created by Harmanpreet Kaur on 2020-01-18.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageview: UIImageView!
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let i = image{
            imageview.image = i
        }
        
    }


}

