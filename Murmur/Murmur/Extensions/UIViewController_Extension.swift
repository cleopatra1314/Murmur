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
    
    func presentCancelAlert(message: String, viewController: UIViewController) {
        // 創造一個 UIAlertController 的實例。
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        // 加入確定的動作。
        let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        // 加入取消的動作。
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        alertController.addAction(cancelAction)
        
        // 呈現 alertController。
        viewController.present(alertController, animated: true)
    }
    
    func presentDeletionAlert() {
        // 創造一個 UIAlertController 的實例。
        let alertController = UIAlertController(title: nil, message: "確定要刪除這個東西嗎？", preferredStyle: .alert)
        
        // 加入刪除的動作。
        let deleteAction = UIAlertAction(title: "刪除", style: .destructive) { _ in
//            self.deleteSomething()
        }
        alertController.addAction(deleteAction)
        
        // 加入取消的動作。
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        alertController.addAction(cancelAction)
        
        // 呈現 alertController。
        present(alertController, animated: true)
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
        
            if let data = image.jpegData(compressionQuality: 0.3) {
                
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
