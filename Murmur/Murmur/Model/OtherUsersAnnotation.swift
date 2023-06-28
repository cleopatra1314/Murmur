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
    var userName: String
    var userImage: String
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(userUID: String, userName: String, userImage: String, coordinate: CLLocationCoordinate2D) {
        self.userUID = userUID
        self.userName = userName
        self.userImage = userImage
        self.coordinate = coordinate
    }
}
