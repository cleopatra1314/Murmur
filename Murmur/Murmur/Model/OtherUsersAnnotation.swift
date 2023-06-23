//
//  OtherUsersAnnotation.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/20.
//

import Foundation
import MapKit

class OtherUsersAnnotation: NSObject, MKAnnotation {
    
    var userUID: String
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(userUID: String, coordinate: CLLocationCoordinate2D) {
        self.userUID = userUID
        self.coordinate = coordinate
    }
}
