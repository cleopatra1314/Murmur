//
//  UIView_Extension.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/25.
//

import Foundation
import UIKit

extension UIView {
    
    func findViewController() -> UIViewController? {
        
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
