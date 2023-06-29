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
    
    func addShineShadow() {
            self.shadowOffset = CGSize(width: 0, height: 0)
            self.shadowOpacity = 0.7
            self.shadowRadius = 6
            self.shadowColor = UIColor.ShadowLight?.cgColor
            self.masksToBounds = false
        }
    
    func addWhiteShadow() {
            self.shadowOffset = CGSize(width: 0, height: 0)
            self.shadowOpacity = 0.7
            self.shadowRadius = 6
            self.shadowColor = UIColor.GrayScale20?.cgColor
            self.masksToBounds = false
        }
    
    func addMessagesShadow() {
            self.shadowOffset = CGSize(width: 0, height: 0)
            self.shadowOpacity = 0.7
            self.shadowRadius = 3
            self.shadowColor = UIColor.ShadowOfMessage?.cgColor
            self.masksToBounds = false
        }
}
