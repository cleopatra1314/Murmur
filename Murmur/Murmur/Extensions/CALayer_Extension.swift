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
            self.shadowRadius = 6
        self.shadowColor = UIColor.ShadowLight?.cgColor
            self.masksToBounds = false
        }
}
