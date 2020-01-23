//
//  MapVC.swift
//  groupH_FinalProject
//
//  Created by Abhinav Bhardwaj on 2020-01-23.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapVC: UIViewController , MKMapViewDelegate, CLLocationManagerDelegate  {

    @IBOutlet weak var navigationButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }
    

    @IBAction func navButtonPressed(_ sender: UIButton) {
    
        // get the route
      
    }
    
    
    

}
