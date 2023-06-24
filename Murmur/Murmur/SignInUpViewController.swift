//
//  SignInUpViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/24.
//

import Foundation
import UIKit
import SnapKit

class SignInUpViewController: UIViewController {
    
//    let attributes: [NSAttributedString.Key: Any] = [
//        .font: UIFont(name: "Helvetica-Bold", size: 18.0) ?? UIFont.systemFont(ofSize: 18.0),
//        .foregroundColor: UIColor.red,
//        .backgroundColor: UIColor.green,
//        .underlineStyle: NSUnderlineStyle.single.rawValue,
//        .kern: 1.5,
//        .paragraphStyle: NSMutableParagraphStyle()
//    ]
    let emailTextField: MessageTypeTextField = {
        let emailTextField = MessageTypeTextField()
        emailTextField.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        emailTextField.textColor = .white
        emailTextField.placeholder = "請輸入 email"
        emailTextField.attributedPlaceholder = NSAttributedString(string: "請輸入", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 18.0),
            NSAttributedString.Key.kern: 1.5,
            NSAttributedString.Key.foregroundColor: UIColor.green
        ])
        emailTextField.layer.borderColor = UIColor.darkGray.cgColor
        emailTextField.layer.borderWidth = 1
        return emailTextField
    }()
    let passwordTextField: MessageTypeTextField = {
        let passwordTextField = MessageTypeTextField()
        passwordTextField.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        passwordTextField.textColor = .white
        passwordTextField.placeholder = "請輸入密碼"
        passwordTextField.layer.borderColor = UIColor.darkGray.cgColor
        passwordTextField.layer.borderWidth = 1
        return passwordTextField
    }()
    let signInButton: UIButton = {
        let signInButton = UIButton()
        signInButton.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        signInButton.backgroundColor = .black
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.addTarget(self, action: #selector(signInButtonTouchUpInside), for: .touchUpInside)
        return signInButton
    }()
    let signUpButton: UIButton = {
        let signUpButton = UIButton()
        signUpButton.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        signUpButton.backgroundColor = .black
        signUpButton.setTitle("Sign Up", for: .normal)
        return signUpButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutView()
        //串登入、註冊頁，試看看這頁要放哪
    }
    
    func layoutView(){
        [emailTextField, passwordTextField, signInButton, signUpButton].forEach { subview in
            self.view.addSubview(subview)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(100)
            make.centerX.equalTo(self.view)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(32)
            make.centerX.equalTo(self.view)
        }
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(32)
            make.centerX.equalTo(self.view)
        }
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(32)
            make.centerX.equalTo(self.view)
        }
        
    }
    
    @objc func signInButtonTouchUpInside() {
        createTabBarController()
    }
    
    @objc func signUpButtonTouchUpInside() {
        
    }
    
    private func createTabBarController() {
        
        // 创建 TabBarController
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .lightGray
        
        // 创建视图控制器
        let firstViewController = HomePageViewController()
        let secondViewController = ChatViewController()
        let thirdViewController = PostViewController()
        let fourthViewController = ProfileViewController()
        
        // 将视图控制器添加到 TabBarController
        let thirdNavigationController = UINavigationController(rootViewController: thirdViewController)
        let secondNavigationController = UINavigationController(rootViewController: secondViewController)
        tabBarController.viewControllers = [firstViewController, secondNavigationController, thirdNavigationController, fourthViewController]
        
        // 設定 tabBarItem
        if let tabBarItems = tabBarController.tabBar.items {
            
            let homeTabBarItem: UITabBarItem = {
                // 根据索引找到目标 TabBarItem
                let homeTabBarItem = tabBarItems[0]
                // 修改 TabBarItem 的属性
                homeTabBarItem.title = "首頁"
                homeTabBarItem.image = UIImage(named: "Icons_Home.png")
                return homeTabBarItem
            }()
            
            let _: UITabBarItem = {
                // 根据索引找到目标 TabBarItem
                let chatRoomTabBarItem = tabBarItems[1]
                // 修改 TabBarItem 的属性
                chatRoomTabBarItem.title = "聊天"
                chatRoomTabBarItem.image = UIImage(named: "Icons_ChatRoom.png")
                return chatRoomTabBarItem
            }()
            
            let _: UITabBarItem = {
                // 根据索引找到目标 TabBarItem
                let postTabBarItem = tabBarItems[2]
                // 修改 TabBarItem 的属性
                postTabBarItem.title = "塗鴉"
                postTabBarItem.image = UIImage(named: "Icons_Post.png")
                return postTabBarItem
            }()
            
            let _: UITabBarItem = {
                // 根据索引找到目标 TabBarItem
                let profileTabBarItem = tabBarItems[3]
                // 修改 TabBarItem 的属性
                profileTabBarItem.title = "個人"
                profileTabBarItem.image = UIImage(named: "Icons_Profile.png")
                return profileTabBarItem
            }()
        }
        
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.modalTransitionStyle = .crossDissolve
        present(tabBarController, animated: true)
        
    }
    
}
