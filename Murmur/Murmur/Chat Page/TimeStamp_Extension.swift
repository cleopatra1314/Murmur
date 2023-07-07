//
//  TimeStamp_Extension.swift
//  Murmur
//
//  Created by cleopatra on 2023/7/6.
//

import Foundation
import FirebaseFirestore

extension Timestamp: Comparable {
    public static func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
        return lhs.dateValue() < rhs.dateValue()
    }
    
    public static func <= (lhs: Timestamp, rhs: Timestamp) -> Bool {
        return lhs.dateValue() <= rhs.dateValue()
    }
    
    public static func > (lhs: Timestamp, rhs: Timestamp) -> Bool {
        return lhs.dateValue() > rhs.dateValue()
    }
    
    public static func >= (lhs: Timestamp, rhs: Timestamp) -> Bool {
        return lhs.dateValue() >= rhs.dateValue()
    }
}
