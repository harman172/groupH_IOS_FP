//
//  MapVC.swift
//  groupH_FinalProject
//
//  Created by Abhinav Bhardwaj on 2020-01-23.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit
import MapKit


class MapVC: UIViewController , MKMapViewDelegate  {

    @IBOutlet weak var navigationButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        
        
        mapView.delegate = self
        
        super.viewDidLoad()

        
    }
    

    @IBAction func navButtonPressed(_ sender: UIButton) {
    
        // get the route
      
    }
    
    
    func getDirections(){
        
        
        
        
        
    
    }
    
    
    

}
