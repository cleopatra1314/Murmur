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
    
    // 起始頁 button
    func addSaturatedShadow1() {
            self.shadowOffset = CGSize(width: 0, height: -5)
            self.shadowOpacity = 1
            self.shadowRadius = 3
            self.shadowColor = UIColor.ShadowLight3?.cgColor
            self.masksToBounds = false
        }
    
    // 起始頁 button
    func addSaturatedShadow() {
            self.shadowOffset = CGSize(width: 0, height: 0)
            self.shadowOpacity = 1
            self.shadowRadius = 1
            self.shadowColor = UIColor.SecondarySaturate?.cgColor
            self.masksToBounds = false
        }
    
    func addShineShadow() {
            self.shadowOffset = CGSize(width: 0, height: 0)
        self.shadowOpacity = 0.6
            self.shadowRadius = 4
            self.shadowColor = UIColor.ShadowLight?.cgColor
            self.masksToBounds = false
        }
    
    func addBarShadow() {
            self.shadowOffset = CGSize(width: 0, height: -2)
        self.shadowOpacity = 0.8
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
            self.shadowOpacity = 0.6
            self.shadowRadius = 6
            self.shadowColor = UIColor.ShadowOfMessage?.cgColor
            self.masksToBounds = false
        }
}
