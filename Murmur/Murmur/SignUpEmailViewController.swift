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
import SnapKit

class SignUpEmailViewController: UIViewController {
    
    let blackView = UIView(frame: UIScreen.main.bounds)
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
        passwordLabel.textColor = .SecondarySaturate
        return passwordLabel
    }()
    private let passwordTextField: MessageTypeTextField = {
        let passwordTextField = MessageTypeTextField()
        passwordTextField.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        passwordTextField.textColor = .SecondaryDark
        passwordTextField.placeholder = "Must contain at least 6 characters"
        passwordTextField.layer.cornerRadius = 12
        passwordTextField.backgroundColor = .GrayScale20?.withAlphaComponent(0.9)
        passwordTextField.layer.addShineShadow()
        return passwordTextField
    }()
    private let EULALabel: UILabel = {
        let EULALabel = UILabel()
        EULALabel.textColor = .SecondaryMidDark
        EULALabel.text = "By creating an account, you agree to the:"
        return EULALabel
    }()
    lazy var termsOfServiceButton: UIButton = {
        let termsOfServiceButton = UIButton()
        termsOfServiceButton.setTitle("Terms Of Service,", for: .normal)
        termsOfServiceButton.setTitleColor(UIColor.SecondarySaturate, for: .normal)
        termsOfServiceButton.addTarget(self, action: #selector(termsOfServiceButtonTouchUpInside), for: .touchUpInside)
        return termsOfServiceButton
    }()
    lazy var privacyPolicyButton: UIButton = {
        let privacyPolicyButton = UIButton()
        privacyPolicyButton.setTitle("Privacy Policy", for: .normal)
        privacyPolicyButton.setTitleColor(UIColor.SecondarySaturate, for: .normal)
        privacyPolicyButton.addTarget(self, action: #selector(privacyPolicyButtonTouchUpInside), for: .touchUpInside)
        return privacyPolicyButton
    }()
    private lazy var nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.setTitle("Next", for: .normal)
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
        
    // swiftlint:disable function_body_length
    @objc func termsOfServiceButtonTouchUpInside() {
        
        let privacyPolicyText = """
                
                End-User License Agreement (EULA) of Murmur Wall

                This End-User License Agreement ("EULA") is a legal agreement between you and Murmur Wall . Our EULA was created by EULA Template for Murmur Wall.

                This EULA agreement governs your acquisition and use of our Murmur Wall software ("Software") directly from Murmur Wall or indirectly through a Murmur Wall authorized reseller or distributor (a "Reseller").

                Please read this EULA agreement carefully before completing the installation process and using the Murmur Wall software. It provides a license to use the Murmur Wall software and contains warranty information and liability disclaimers.

                If you register for a free trial of the Murmur Wall software, this EULA agreement will also govern that trial. By clicking "accept" or installing and/or using the Murmur Wall software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement.

                If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.

                This EULA agreement shall apply only to the Software supplied by Murmur Wall herewith regardless of whether other software is referred to or described herein. The terms also apply to any Murmur Wall updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply.

                License Grant

                Murmur Wall hereby grants you a personal, non-transferable, non-exclusive licence to use the Murmur Wall software on your devices in accordance with the terms of this EULA agreement.

                You are permitted to load the Murmur Wall software (for example a PC, laptop, mobile or tablet) under your control. You are responsible for ensuring your device meets the minimum requirements of the Murmur Wall software.

                You are not permitted to:

                Edit, alter, modify, adapt, translate or otherwise change the whole or any part of the Software nor permit the whole or any part of the Software to be combined with or become incorporated in any other software, nor decompile, disassemble or reverse engineer the Software or attempt to do any such things
                Reproduce, copy, distribute, resell or otherwise use the Software for any commercial purpose
                Allow any third party to use the Software on behalf of or for the benefit of any third party
                Use the Software in any way which breaches any applicable local, national or international law
                use the Software for any purpose that Murmur Wall considers is a breach of this EULA agreement
                Intellectual Property and Ownership

                Murmur Wall shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of Murmur Wall .

                Murmur Wall reserves the right to grant licences to use the Software to third parties.

                Termination

                This EULA agreement is effective from the date you first use the Software and shall continue until terminated. You may terminate it at any time upon written notice to Murmur Wall .

                It will also terminate immediately if you fail to comply with any term of this EULA agreement. Upon such termination, the licenses granted by this EULA agreement will immediately terminate and you agree to stop all access and use of the Software. The provisions that by their nature continue and survive will survive any termination of this EULA agreement.

                Governing Law

                This EULA agreement, and any dispute arising out of or in connection with this EULA agreement, shall be governed by and construed in accordance with the laws of tw.
                """
        
        let controller = UIAlertController(title: "Terms Of Service", message: privacyPolicyText, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
        }
        controller.addAction(okAction)
//        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
//        controller.addAction(cancelAction)
        present(controller, animated: true)
        
//        let presentVC = PopupViewController()
//        presentVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
////        presentVC.modalPresentationStyle = UIModalPresentationStyle.custom
//        presentVC.modalPresentationStyle = .custom
//        presentVC.modalTransitionStyle = .crossDissolve
//
//        self.present(presentVC, animated: true) { [self] in
            
//            self.blackView.backgroundColor = .black
//            blackView.alpha = 0
//            self.navigationController?.view.addSubview(blackView)
////            self.view.addSubview(self.blackView)
////            self.view.bringSubviewToFront(self.blackView)
//            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.05, delay: 0) {
//                self.blackView.alpha = 0.5
//            }
            
//        }
    }
    
    @objc func privacyPolicyButtonTouchUpInside() {
        
        let pushVC = PrivacyPolicyViewController()
        self.navigationController?.pushViewController(pushVC, animated: true)
   
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
        
        [logoMessageTypingAnimationView, titleLabel, stack, emailLabel, emailTextField, passwordLabel, passwordTextField, EULALabel, termsOfServiceButton, privacyPolicyButton, nextButton].forEach { subview in
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
            make.bottom.equalTo(passwordTextField.snp.top).offset(-5)
            make.leading.equalTo(self.view).offset(30)
        }
        passwordTextField.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.snp.centerY).offset(8)
            make.leading.equalTo(self.view).offset(30)
            make.trailing.equalTo(self.view).offset(-30)
            make.height.equalTo(43)
        }
        EULALabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.equalTo(passwordTextField)
        }
        termsOfServiceButton.snp.makeConstraints { make in
            make.top.equalTo(EULALabel.snp.bottom).offset(0)
            make.leading.equalTo(EULALabel)
        }
        privacyPolicyButton.snp.makeConstraints { make in
            make.top.equalTo(EULALabel.snp.bottom).offset(0)
            make.leading.equalTo(termsOfServiceButton.snp.trailing).offset(4)
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
            make.top.equalTo(passwordTextField.snp.bottom).offset(112)
        }
        
    }
}
