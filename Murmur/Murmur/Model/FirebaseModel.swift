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

struct Murmurs: Codable, Identifiable {
//    var id: ObjectIdentifier
    @DocumentID var id: String?
    
    let userUID: String
    let userEmail: String?
    let location: [String: Double]
    let murmurMessage: String
    let murmurImage: String
    let selectedTags: Array<String>
    let createTime: Date
//    @ServerTimestamp var createTime: Timestamp
}

struct Users: Codable, Identifiable {
    @DocumentID var id: String?
    
    var murmur: String?
    var onlineState: Bool
    let userName: String
    var userPortrait: String
    var location: [String: Double]
}

struct Messages: Codable, Identifiable {
    @DocumentID var id: String?
    
    let createTime: Timestamp
    var messageContent: String
    var senderUUID: String
}

struct ChatRooms: Codable, Identifiable {
    @DocumentID var id: String?
    
    let createTime: Timestamp
    let theOtherUserUID: String
}

// ----------------------------------------
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
