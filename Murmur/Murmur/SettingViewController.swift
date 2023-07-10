//
//  SettingViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/30.
//

import Foundation
import UIKit
import FirebaseAuth

class SettingViewController: UIViewController {
    
    lazy var signOutButton: UIButton = {
        let signOutButton = UIButton()
        signOutButton.frame = CGRect(x: 150, y: 200, width: 120, height: 40)
        signOutButton.backgroundColor = .SecondaryDefault
        signOutButton.setTitle("登出", for: .normal)
        signOutButton.layer.cornerRadius = 10
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return signOutButton
    }()
    lazy var deleteAccountButton: UIButton = {
        let deleteAccountButton = UIButton()
        deleteAccountButton.frame = CGRect(x: 150, y: 260, width: 120, height: 40)
        deleteAccountButton.backgroundColor = .SecondaryDefault
        deleteAccountButton.setTitle("刪除帳號", for: .normal)
        deleteAccountButton.layer.cornerRadius = 10
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTouchUpInside), for: .touchUpInside)
        return deleteAccountButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .SecondaryLight
        self.view.addSubview(signOutButton)
        self.view.addSubview(deleteAccountButton)
        
    }
    
    @objc func deleteAccountButtonTouchUpInside() {
        
        // 創造一個 UIAlertController 的實例。
        let alertController = UIAlertController(title: "提醒", message: "確定要刪除帳號嗎？", preferredStyle: .alert)
        
        // 加入確定的動作。
        let okAction = UIAlertAction(title: "確定", style: .default) { alertAction in
            
            let user = Auth.auth().currentUser

            user?.delete { error in
                if let error = error {
                    print("Error: Account delete failed.", error)
                } else {
                    // 刪除 chatRooms 底下 documents
                    database.collection("userTest").document(currentUserUID).collection("chatRooms").getDocuments { querySnapshot, error in
                        
                        if let error = error {
                                    print("Error getting documents: \(error)")
                                } else {
                                    for document in querySnapshot!.documents {
                                        document.reference.delete()
                                    }
                                }
                    }
                  
                    // 刪除 postedMurmurs 底下 documents
                    database.collection("userTest").document(currentUserUID).collection("postedMurmurs").getDocuments { querySnapshot, error in
                        
                        if let error = error {
                                    print("Error getting documents: \(error)")
                                } else {
                                    for document in querySnapshot!.documents {
                                        document.reference.delete()
                                    }
                                }
                    }
                  
                    // 刪除 userID collection
                    database.collection("userTest").document(currentUserUID).delete()
                
                    // 等到上面的 firebase 資料都刪除後再來 present
                    let initialVC = InitialViewController()
                    initialVC.modalPresentationStyle = .fullScreen
                    initialVC.modalTransitionStyle = .crossDissolve
                    self.present(initialVC, animated: true)
              }
            }
            
        }
        alertController.addAction(okAction)
        
        // 加入取消的動作。
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { alertAction in
            return
        }
        alertController.addAction(cancelAction)
        
        // 呈現 alertController。
        present(alertController, animated: true)
        
    }
    
    @objc func signOut() {
        
//        do {
//            try Auth.auth().signOut()
//            showAlert(title: "登出成功", message: "請再次登入才能享有各式功能哦！", viewController: self)
//
//            database.collection("userTest").document(currentUserUID).setData([
//                "onlineState": false
//            ], merge: true)
//
//            print("登出成功")
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
        
        // 創造一個 UIAlertController 的實例。
        let alertController = UIAlertController(title: "提醒", message: "確定要登出嗎？", preferredStyle: .alert)
        
        // 加入確定的動作。
        let okAction = UIAlertAction(title: "確定", style: .default) { alertAction in
            
            do {
                try Auth.auth().signOut()
            
                database.collection("userTest").document(currentUserUID).setData([
                    "onlineState": false
                ], merge: true)
                
                let initialVC = InitialViewController()
                initialVC.modalPresentationStyle = .fullScreen
                initialVC.modalTransitionStyle = .crossDissolve
                self.present(initialVC, animated: true)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        alertController.addAction(okAction)
        
        // 加入取消的動作。
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { alertAction in
            return
        }
        alertController.addAction(cancelAction)
        
        // 呈現 alertController。
        present(alertController, animated: true)
        
    }
    
    func confirmSignOutAlert(message: String, viewController: UIViewController) {
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
    
}
