//
//  SignInViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/7/4.
//

import Foundation
import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "BlueParrot.png")
        logoImageView.contentMode = .scaleAspectFit
        return logoImageView
    }()
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Welcome back to the Murmur world."
        titleLabel.textColor = .PrimaryMidDark
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    private let emailLabel: UILabel = {
        let emailLabel = UILabel()
        emailLabel.text = "Email"
        emailLabel.textColor = .SecondaryMiddle
        return emailLabel
    }()
    private let emailTextField: MessageTypeTextField = {
        let emailTextField = MessageTypeTextField()
        emailTextField.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        emailTextField.textColor = .SecondaryDark
        emailTextField.placeholder = "請輸入 email"
//        emailTextField.attributedPlaceholder = NSAttributedString(string: "請輸入 email", attributes: [
//            NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 18.0),
//            NSAttributedString.Key.kern: 1.5,
////            NSAttributedString.Key.foregroundColor: UIColor.green
//        ])
        emailTextField.layer.cornerRadius = 12
        emailTextField.backgroundColor = .GrayScale20?.withAlphaComponent(0.9)
        emailTextField.layer.addShineShadow()
        return emailTextField
    }()
    private let passwordLabel: UILabel = {
        let passwordLabel = UILabel()
        passwordLabel.text = "Password"
        passwordLabel.textColor = .SecondaryMiddle
        return passwordLabel
    }()
    private let passwordTextField: MessageTypeTextField = {
        let passwordTextField = MessageTypeTextField()
        passwordTextField.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        passwordTextField.textColor = .SecondaryDark
        passwordTextField.placeholder = "請輸入密碼"
        passwordTextField.layer.cornerRadius = 12
        passwordTextField.backgroundColor = .GrayScale20?.withAlphaComponent(0.9)
        passwordTextField.layer.addShineShadow()
        return passwordTextField
    }()
    private let errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.textColor = .ErrorDefault
        return errorLabel
    }()
    private lazy var signInWithEmailButton: UIButton = {
        let signInWithEmailButton = UIButton()
        signInWithEmailButton.setTitle("登入", for: .normal)
        signInWithEmailButton.setTitleColor(.GrayScale0, for: .normal)
        signInWithEmailButton.backgroundColor = .SecondaryMiddle
        signInWithEmailButton.layer.cornerRadius = 12
        signInWithEmailButton.addTarget(self, action: #selector(signInWithEmailButtonTouchUpInside), for: .touchUpInside)
        signInWithEmailButton.addTarget(self, action: #selector(signInWithEmailButtonTouchDown), for: .touchDown)
        return signInWithEmailButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func signInWithEmailButtonTouchDown() {// 点击改变背景色
        signInWithEmailButton.backgroundColor = UIColor.SecondarySaturate
    }
    
    func createTabBarController() {
        
        let customTabBarController = CustomTabBarController()

        present(customTabBarController, animated: true)
        
    }
    
    // MARK: Sign in，登入後使用者將維持登入狀態，就算我們重新啟動 App ，使用者還是能保持登入
    @objc func signInWithEmailButtonTouchUpInside() {
        
        let userEmail = self.emailTextField.text
        let userPassward = self.passwordTextField.text
        
        guard userEmail != "" else {
            self.errorLabel.text = "Ooops! 你是不是沒填帳號或密碼"
            return
        }
        guard userPassward != "" else {
            self.errorLabel.text = "Ooops! 你是不是沒填帳號或密碼"
            return
        }
        
        Auth.auth().signIn(withEmail: userEmail!, password: userPassward!) { result, error in
            // ??
            guard error == nil else {
                print("登入失敗", error?.localizedDescription ?? "no error?.localizedDescription")
                self.errorLabel.text = "打錯帳號密碼齁，再給你一次機會"
                return
                
            }
            guard let userID = result?.user.uid else {
                
                return
            }
            currentUserUID = userID
            database.collection("userTest").document(currentUserUID).setData([
                "onlineState": true
            ], merge: true)
            print("\(result?.user.uid ?? "") 登入成功")
            self.createTabBarController()
            
        }
        
    }
    
    func layoutView() {
        
        self.view.backgroundColor = .PrimaryLighter
        
        [logoImageView, titleLabel, emailLabel, emailTextField, passwordLabel, passwordTextField, errorLabel, signInWithEmailButton].forEach { subview in
            self.view.addSubview(subview)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(22)
            make.height.width.equalTo(34)
            make.centerX.equalTo(self.view)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(4)
            make.leading.lessThanOrEqualTo(self.view).offset(72)
            make.trailing.lessThanOrEqualTo(self.view).offset(-72)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.snp.centerY)
            make.leading.equalTo(self.view).offset(30)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(5)
            make.leading.equalTo(self.view).offset(30)
            make.trailing.equalTo(self.view).offset(-30)
            make.height.equalTo(43)
        }
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.equalTo(passwordTextField)
        }
        emailTextField.snp.makeConstraints { make in
            make.bottom.equalTo(passwordLabel.snp.top).offset(-18)
            make.leading.equalTo(self.view).offset(30)
            make.trailing.equalTo(self.view).offset(-30)
            make.height.equalTo(43)
        }
        emailLabel.snp.makeConstraints { make in
            make.bottom.equalTo(emailTextField.snp.top).offset(-5)
            make.leading.equalTo(passwordTextField)
        }
        signInWithEmailButton.snp.makeConstraints { make in
            make.height.equalTo(39)
            make.width.equalTo(119)
            make.centerX.equalTo(self.view)
            make.top.equalTo(passwordTextField.snp.bottom).offset(94)
        }
        
    }
}
