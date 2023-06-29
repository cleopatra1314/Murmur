//
//  UIViewController_Extension.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/25.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}
