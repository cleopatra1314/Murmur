//
//  UIViewController_Extension.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/25.
//

import Foundation
import UIKit
import FirebaseStorage
import MapKit 

extension UIViewController {
    
    /// Animates a view to scale in and display
    func animateScaleIn(desiredView: UIView) {
        let backgroundView = self.view!
        backgroundView.addSubview(desiredView)
        backgroundView.bringSubviewToFront(desiredView)
        desiredView.center = backgroundView.center
        desiredView.isHidden = false
        
        desiredView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        desiredView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
//            desiredView.transform = CGAffineTransform.identity
        }
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    /// Animates a view to scale out remove from the display
    func animateScaleOut(desiredView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            desiredView.alpha = 0
            
        }, completion: { (success: Bool) in
            self.tabBarController?.tabBar.isHidden = false
            desiredView.removeFromSuperview()
        })
        
        UIView.animate(withDuration: 0.2, animations: {
            
        }, completion: { _ in
            
        })
        
    }

    
    ///   - message: 提示訊息
    ///   - vc: 要在哪一個 UIViewController 上呈現
    ///   - actionHandler: 按下按鈕後要執行的動作，沒有的話就填 nil
    func showCustomAlert(title: String, message: String, viewController: UIViewController, okMessage: String, closeMessage: String, okActionHandler: (() -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // 加入確定的動作。
        let okAction = UIAlertAction(title: okMessage, style: .default) { okAction in
            okActionHandler?()
        }
        alertController.addAction(okAction)
        
        let closeAction = UIAlertAction(title: closeMessage, style: .default) { action in
            return
        }
        alertController.addAction(closeAction)
        
        viewController.present(alertController, animated: true, completion: nil)
        
    }
    
    func createTabBarController() {
        
        let customTabBarController = CustomTabBarController()
        present(customTabBarController, animated: true)
        
    }
    
    func showAlert(title: String, message: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func presentCancelAlert(message: String, viewController: UIViewController) {
        // 創造一個 UIAlertController 的實例。
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        // 加入確定的動作。
        let okAction = UIAlertAction(title: "Delete", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        // 加入取消的動作。
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
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
    
    func reverseGeocodeLocation(latitude: Double, longitude: Double, completion: @escaping (String) -> Void) {
        let geoCoder = CLGeocoder()
        let currentLocation = CLLocation(
            latitude: latitude,
            longitude: longitude
        )
        
        // 设置地理编码器的区域设置为中文
        let chineseLocale = Locale(identifier: "zh_CN")
//        geoCoder.locale = chineseLocale
        
        geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if let error = error {
                // 這邊可以加入一些你的 Try Error 機制
                print("Error: \(error.localizedDescription)")
                completion("")
            } else if let placemark = placemarks?.first {
                // 处理地理编码结果
//                let address = "\(placemark.subLocality ?? "no subLocality") \(placemark.locality ?? "no locality")\(placemark.thoroughfare ?? "")\(placemark.subThoroughfare ?? "")"
                let address = "\(placemark.locality ?? "no locality")  \(placemark.thoroughfare ?? "")"
    
                completion(address)
            } else {
                // 没有找到地理编码结果
                completion("Find no geography decoding result.")
            }
            /*  name            街道地址
             *  country         國家
             *  province        省籍
             *  locality        城市
             *  sublocality     縣市、區
             *  route           街道、路名
             *  streetNumber    門牌號碼
             *  postalCode      郵遞區號
             */
            
        }
    
    }
    
}
