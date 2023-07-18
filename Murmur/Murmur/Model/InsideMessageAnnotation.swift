//
//  InsideMessageAnnotation.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/20.
//

import Foundation
import MapKit

class InsideMessageAnnotation: NSObject, MKAnnotation {
    
    var murmurData: Murmurs
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(murmurData: Murmurs, coordinate: CLLocationCoordinate2D) {
        self.murmurData = murmurData
        self.coordinate = coordinate
    }
}
