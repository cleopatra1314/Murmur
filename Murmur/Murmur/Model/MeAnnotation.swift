//
//  MeAnnotation.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/20.
//

import Foundation
import MapKit

class MeAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
