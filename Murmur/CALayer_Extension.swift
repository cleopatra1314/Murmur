//
//  CALayer_Extension.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/28.
//

import Foundation
import UIKit

extension CALayer {
    
    func roundCorners(radius: CGFloat) {
            self.cornerRadius = radius
        }
    
    func addShadow() {
            self.shadowOffset = CGSize(width: 0, height: 0)
            self.shadowOpacity = 0.7
            self.shadowRadius = 3
            self.shadowColor = UIColor(red: 171/255, green: 255/255, blue: 230/255, alpha: 1).cgColor
            self.masksToBounds = false
        }
}

