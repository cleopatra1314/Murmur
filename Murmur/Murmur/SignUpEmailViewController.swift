//
//  SignUpEmailViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/7/4.
//

import Foundation
import UIKit
import FirebaseAuth
import Lottie

class SignUpEmailViewController: UIViewController {
    
    let logoMessageTypingAnimationView = LottieAnimationView(name: "LogoMessageTyping")
    
    let signUpNickNameVC = SignUpNickNameViewController()
    
//    private let logoMessageTypingAnimationView: UIImageView = {
//        let logoMessageTypingAnimationView = UIImageView()
//        logoMessageTypingAnimationView.image = UIImage(named: "BlueParrot.png")
//        logoMessageTypingAnimationView.contentMode = .scaleAspectFit
//        return logoMessageTypingAnimationView
//    }()
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Create a Murmur Wall Account"
        titleLabel.font = UIFont(name: "PingFangTC-Medium", size: 20)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .PrimaryMidDarkContrast
        return titleLabel
    }()
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 18
        return stack
    }()
    private let ball1: UIView = {
        let ball1 = UIView()
        ball1.frame = CGRect(x: 0, y: 0, width: 8, height: 8)
        ball1.layer.cornerRadius = 4
        ball1.backgroundColor = .PrimaryMiddle
        return ball1
    }()
    private let ball2: UIView = {
        let ball2 = UIView()
        ball2.frame = CGRect(x: 0, y: 0, width: 8, height: 8)
        ball2.layer.cornerRadius = 4
        ball2.layer.borderColor = UIColor.PrimaryMiddle?.cgColor
        ball2.layer.borderWidth = 2
        return ball2
    }()
    private let emailLabel: UILabel = {
        let emailLabel = UILabel()
        emailLabel.text = "Email"
        emailLabel.textColor = .SecondarySaturate
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
        passwordLabel.textColor = .SecondarySaturate
        return passwordLabel
    }()
    private let passwordTextField: MessageTypeTextField = {
        let passwordTextField = MessageTypeTextField()
        passwordTextField.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        passwordTextField.textColor = .SecondaryDark
        passwordTextField.placeholder = "請輸入 6 個數字以上密碼"
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
    private lazy var nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.setTitle("下一步", for: .normal)
        nextButton.setTitleColor(.GrayScale20, for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "PingFangTC-Medium", size: 16)
        nextButton.backgroundColor = .SecondaryMiddle
        nextButton.layer.cornerRadius = 12
        nextButton.addTarget(self, action: #selector(nextButtonTouchUpInside), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTouchDown), for: .touchDown)
        return nextButton
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
    
    // 當點擊view任何一處鍵盤收起
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func nextButtonTouchDown() {// 点击改变背景色
        nextButton.backgroundColor = UIColor.SecondarySaturate
    }
    
    @objc func nextButtonTouchUpInside() {
        
        signUpNickNameVC.userEmail = emailTextField.text
        signUpNickNameVC.userPassword = passwordTextField.text
        self.navigationController?.pushViewController(signUpNickNameVC, animated: true)
        
    }
    
    func layoutView() {
        
        self.view.backgroundColor = .PrimaryLighter
        
        [logoMessageTypingAnimationView, titleLabel, stack, emailLabel, emailTextField, passwordLabel, passwordTextField, errorLabel, nextButton].forEach { subview in
            self.view.addSubview(subview)
        }
        
        [ball1, ball2].forEach { subview in
            stack.addArrangedSubview(subview)
        }
        
        ball1.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(stack)
            make.height.width.equalTo(8)
        }
        
        ball2.snp.makeConstraints { make in
            make.top.trailing.bottom.equalTo(stack)
            make.height.width.equalTo(8)
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
        stack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
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
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(39)
            make.width.equalTo(119)
            make.trailing.equalTo(self.view).offset(-30)
            make.top.equalTo(passwordTextField.snp.bottom).offset(94)
        }
        
    }
}
