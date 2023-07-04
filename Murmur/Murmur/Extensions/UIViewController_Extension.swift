//
//  UIViewController_Extension.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/25.
//

import Foundation
import UIKit
import FirebaseStorage

extension UIViewController {
    
    func showAlert(title: String, message: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
//    func showAlertAndNav(title: String, message: String, viewController: UIViewController) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "確定", style: .default) { _ in
//            guard ((viewController as? HomePageViewController) != nil) else { return }
//            viewController.locationManager.requestWhenInUseAuthorization()
//        }
//        alertController.addAction(okAction)
//        viewController.present(alertController, animated: true, completion: nil)
//    }
    
    // MARK: 上傳到 firestorage 並拿到 captured image URL
    func uploadPhoto(image: UIImage?, completion: @escaping (Result<URL, Error>) -> Void) {
            
            guard let image else { return }
            let fileReference = Storage.storage().reference().child(UUID().uuidString + ".jpg")
            if let data = image.jpegData(compressionQuality: 0.9) {
                
                fileReference.putData(data, metadata: nil) { result in
                    switch result {
                    case .success:
                         fileReference.downloadURL(completion: completion)
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
    }
    
}
