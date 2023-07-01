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
        self.shadowOpacity = 0.6
            self.shadowRadius = 4
            self.shadowColor = UIColor.ShadowLight?.cgColor
            self.masksToBounds = false
        }
    
    func addBarShadow() {
            self.shadowOffset = CGSize(width: 0, height: -1)
            self.shadowOpacity = 1
            self.shadowRadius = 8
            self.shadowColor = UIColor.ShadowLight2?.cgColor
            self.masksToBounds = false
        }
    
    func addTypingShadow() {
            self.shadowOffset = CGSize(width: 3, height: 3)
        self.shadowOpacity = 1
            self.shadowRadius = 5
            self.shadowColor = UIColor.ShadowLight2?.cgColor
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
