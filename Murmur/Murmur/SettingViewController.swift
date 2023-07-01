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
    
    let signOutButton: UIButton = {
        let signOutButton = UIButton()
        signOutButton.frame = CGRect(x: 150, y: 200, width: 120, height: 40)
        signOutButton.backgroundColor = .SecondaryDefault
        signOutButton.setTitle("登出", for: .normal)
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return signOutButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .GrayScale20
        self.view.addSubview(signOutButton)
        
    }
    
    @objc func signOut() {
        
        do {
            try Auth.auth().signOut()
            showAlert(title: "登出成功", message: "請再次登入才能享有各式功能哦！", viewController: self)
            print("登出成功")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
}
