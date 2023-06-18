//
//  FirebaseModel.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/19.
//

import Foundation
import FirebaseFirestore

struct Murmur: Codable, Identifiable {
    var id: String?
    let userEmail: String
    let location: Array<Double>
    let murmurMessage: String
    let murmurImage: String
    let selectedTags: Array<String>
}
