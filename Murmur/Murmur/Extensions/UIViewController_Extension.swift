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
    
    func createTabBarController() {
        
        let customTabBarController = CustomTabBarController()

        present(customTabBarController, animated: true)
        
    }
    
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
                print("🇹🇼", address)
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
