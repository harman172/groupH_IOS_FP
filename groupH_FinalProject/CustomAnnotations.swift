//
//  File.swift
//  groupH_FinalProject
//
//  Created by Parth Dalwadi on 2020-01-23.
//  Copyright © 2020 Harmanpreet Kaur. All rights reserved.
//

import Foundation
import MapKit

class CustomAnnotations: NSObject, MKAnnotation{

    init(coordinate: CLLocationCoordinate2D, identifier: String) {
        self.coordinate = coordinate
        self.identifier = identifier
    }

    var coordinate: CLLocationCoordinate2D
    var identifier: String
    
}

