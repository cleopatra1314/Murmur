//
//  FirebaseModel.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/19.
//

import Foundation
import UIKit
import FirebaseFirestore
import CoreLocation
import FirebaseFirestoreSwift

struct Murmur: Codable, Identifiable {
//    var id: ObjectIdentifier
    @DocumentID var id: String?
    
    let userEmail: String
    let location: CodableCoordinate
    let murmurMessage: String
    let murmurImage: String
    let selectedTags: Array<String>
    let createTime: Date
//    @ServerTimestamp var createTime: Timestamp
}

// 将 CLLocationCoordinate2D 类型转换为 Codable
struct CodableCoordinate: Codable {
    let latitude: Double
    let longitude: Double

    init(_ coordinate: CLLocationCoordinate2D) {
        latitude = coordinate.latitude
        longitude = coordinate.longitude
    }

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// Date Formatter
//let dateFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
//    return formatter
//}()
