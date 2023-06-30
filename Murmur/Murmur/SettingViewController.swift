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
        signOutButton.setTitle("登出", for: .normal)
        return signOutButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @objc func signOut(){
        
        do {
            try Auth.auth().signOut()
            print("登出成功")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
}
