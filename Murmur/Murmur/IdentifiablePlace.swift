//
//  IdentifiablePlace.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/17.
//

import Foundation
import UIKit
import CoreLocation

class IdentifiablePlace: NSObject {
    let id: UUID
    let location: CLLocationCoordinate2D
    let murmurWord: String
    
    init(lat: Double, long: Double, murmurWord: String) {
        id = UUID()
        location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        self.murmurWord = murmurWord
    }
}
