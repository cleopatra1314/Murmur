//
//  SignInViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/7/4.
//

import Foundation
import UIKit
import FirebaseAuth
import Lottie
import SnapKit

class SignInViewController: UIViewController {
    
    let logoMessageTypingAnimationView = LottieAnimationView(name: "LogoMessageTyping")
    
//    private let logoMessageTypingAnimationView: UIImageView = {
//        let logoMessageTypingAnimationView = UIImageView()
//        logoMessageTypingAnimationView.image = UIImage(named: "BlueParrot.png")
//        logoMessageTypingAnimationView.contentMode = .scaleAspectFit
//        return logoMessageTypingAnimationView
//    }()
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Welcome back to the Murmur world"
        titleLabel.font = UIFont(name: "PingFangTC-Medium", size: 20)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .PrimaryMidDarkContrast
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
        emailTextField.placeholder = "Email"
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
        passwordTextField.placeholder = "Password"
        passwordTextField.layer.cornerRadius = 12
        passwordTextField.backgroundColor = .GrayScale20?.withAlphaComponent(0.9)
        passwordTextField.layer.addShineShadow()
        return passwordTextField
    }()
    private let errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.textColor = .ErrorDefault
        errorLabel.numberOfLines = 0
        return errorLabel
    }()
    private lazy var signInWithEmailButton: UIButton = {
        let signInWithEmailButton = UIButton()
        signInWithEmailButton.setTitle("Sign In", for: .normal)
        signInWithEmailButton.setTitleColor(.GrayScale20, for: .normal)
        signInWithEmailButton.titleLabel?.font = UIFont(name: "PingFangTC-Medium", size: 16)
        signInWithEmailButton.backgroundColor = .SecondaryMiddle
        signInWithEmailButton.layer.cornerRadius = 12
        signInWithEmailButton.addTarget(self, action: #selector(signInWithEmailButtonTouchUpInside), for: .touchUpInside)
        signInWithEmailButton.addTarget(self, action: #selector(signInWithEmailButtonTouchDown), for: .touchDown)
        return signInWithEmailButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        layoutView()
        lottieLogoMessageTyping()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func lottieLogoMessageTyping() {
        logoMessageTypingAnimationView.play()
        logoMessageTypingAnimationView.loopMode = .loop
    }
    
    // 當點擊view任何喔一處鍵盤收起
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func signInWithEmailButtonTouchDown() {// 点击改变背景色
        signInWithEmailButton.backgroundColor = UIColor.SecondarySaturate
    }
    
    // MARK: Sign in，登入後使用者將維持登入狀態，就算我們重新啟動 App ，使用者還是能保持登入
    @objc func signInWithEmailButtonTouchUpInside() {
        
        let userEmail = self.emailTextField.text
        let userPassward = self.passwordTextField.text
        
        guard userEmail != "" else {
            self.errorLabel.text = "Ooops! Make sure you have filled up both account and password"
            return
        }
        guard userPassward != "" else {
            self.errorLabel.text = "Ooops! Make sure you have filled up both account and password"
            return
        }
        
        Auth.auth().signIn(withEmail: userEmail!, password: userPassward!) { result, error in
            // ??
            guard error == nil else {
                print("登入失敗", error?.localizedDescription ?? "no error?.localizedDescription")
                self.errorLabel.text = "Ohh, you type wrong account or password, give you one more chance"
                // "打錯帳號密碼齁，再給你一次機會"
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
        
        [logoMessageTypingAnimationView, titleLabel, emailLabel, emailTextField, passwordLabel, passwordTextField, errorLabel, signInWithEmailButton].forEach { subview in
            self.view.addSubview(subview)
        }
        
        logoMessageTypingAnimationView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(22)
            make.height.width.equalTo(34)
            make.centerX.equalTo(self.view)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoMessageTypingAnimationView.snp.bottom).offset(4)
            make.leading.greaterThanOrEqualTo(self.view).offset(60)
            make.trailing.lessThanOrEqualTo(self.view).offset(-60)
            make.centerX.equalTo(self.view)
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
            make.trailing.equalTo(passwordTextField)
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
