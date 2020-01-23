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
    
    var segueLongitude:Double!
    var segueLatitude:Double!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        print(segueLongitude!)
        print(segueLatitude!)
        showSavedLocation()
       
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        
        
        
    }
    

    @IBAction func navButtonPressed(_ sender: UIButton) {
    
        let dest = CLLocationCoordinate2D(latitude: segueLatitude, longitude: segueLongitude)
        
        
      getRoute(destination: dest)
      
    }
    
    
    func showSavedLocation(){
    
    
        let span = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
       let location = CLLocationCoordinate2D(latitude: segueLatitude!, longitude: segueLongitude!)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }
    
    
   func getRoute(destination:CLLocationCoordinate2D ){
        
        
        let destinationRequest = MKDirections.Request()
        
        let sourceCoordinates = mapView.userLocation.coordinate
       
      
        
        
        let source = CLLocationCoordinate2DMake((sourceCoordinates.latitude), (sourceCoordinates.longitude))
        let destination = CLLocationCoordinate2DMake(destination.latitude, destination.longitude)
        
        print(source)
        print(destination)
        
        
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        
        let finalSource = MKMapItem(placemark: sourcePlacemark)
        let finalDestination = MKMapItem(placemark: destinationPlacemark)
        
       
        destinationRequest.source = finalSource
        destinationRequest.destination = finalDestination
      
         destinationRequest.transportType = .automobile
      
        
        
        let direction = MKDirections(request: destinationRequest)
        
        
        direction.calculate { (responce, error) in
            
            guard let responce = responce else {
                
                if let error = error {
                    print(error)
                    
                }
                return
            }
            let route = responce.routes[0]
        
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
            
        }
        
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKPolyline{
            
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            renderer.strokeColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
            renderer.lineWidth = 2
            
            
            return renderer
            
        }
        
        
        return MKOverlayRenderer()
        
        
        
    }
    
    
    

}
