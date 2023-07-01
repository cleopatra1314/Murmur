//
//  SignInUpViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/24.
//

import Foundation
import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

class SignInUpViewController: UIViewController {
    
    private var userProfileData: Users?
    
//    let attributes: [NSAttributedString.Key: Any] = [
//        .font: UIFont(name: "Helvetica-Bold", size: 18.0) ?? UIFont.systemFont(ofSize: 18.0),
//        .foregroundColor: UIColor.red,
//        .backgroundColor: UIColor.green,
//        .underlineStyle: NSUnderlineStyle.single.rawValue,
//        .kern: 1.5,
//        .paragraphStyle: NSMutableParagraphStyle()
//    ]
    private let emailTextField: MessageTypeTextField = {
        let emailTextField = MessageTypeTextField()
        emailTextField.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        emailTextField.textColor = .white
        emailTextField.placeholder = "請輸入 email"
        emailTextField.attributedPlaceholder = NSAttributedString(string: "請輸入 email", attributes: [
            NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 18.0),
            NSAttributedString.Key.kern: 1.5,
//            NSAttributedString.Key.foregroundColor: UIColor.green
        ])
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailTextField.layer.borderWidth = 1
        return emailTextField
    }()
    private let passwordTextField: MessageTypeTextField = {
        let passwordTextField = MessageTypeTextField()
        passwordTextField.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        passwordTextField.textColor = .white
        passwordTextField.placeholder = "請輸入密碼"
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.borderWidth = 1
        return passwordTextField
    }()
    private let errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.textColor = .red
        return errorLabel
    }()
    private let userNameTextField: MessageTypeTextField = {
        let userNameTextField = MessageTypeTextField()
        userNameTextField.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        userNameTextField.textColor = .white
        userNameTextField.placeholder = "取一個暱稱"
        userNameTextField.layer.borderColor = UIColor.darkGray.cgColor
        userNameTextField.layer.borderWidth = 1
        return userNameTextField
    }()
    private lazy var signInButton: UIButton = {
        let signInButton = UIButton()
        signInButton.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
//        signInButton.backgroundColor = .black
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.addTarget(self, action: #selector(signInButtonTouchUpInside), for: .touchUpInside)
        return signInButton
    }()
    private lazy var signUpButton: UIButton = {
        let signUpButton = UIButton()
        signUpButton.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
//        signUpButton.backgroundColor = .black
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonTouchUpInside), for: .touchUpInside)
        return signUpButton
    }()
    private lazy var visitorButton: UIButton = {
        let visitorButton = UIButton()
        visitorButton.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
//        signUpButton.backgroundColor = .black
        visitorButton.setTitle("只是看看", for: .normal)
        visitorButton.addTarget(self, action: #selector(visitorButtonTouchUpInside), for: .touchUpInside)
        return visitorButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 29/255, green: 35/255, blue: 35/255, alpha: 1)
        layoutView()
        
    }
    
    func layoutView() {
        [emailTextField, passwordTextField, errorLabel, userNameTextField, signInButton, signUpButton, visitorButton].forEach { subview in
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
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(32)
            make.centerX.equalTo(self.view)
        }
        userNameTextField.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(32)
            make.centerX.equalTo(self.view)
        }
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(userNameTextField.snp.bottom).offset(32)
            make.centerX.equalTo(self.view)
        }
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(32)
            make.centerX.equalTo(self.view)
        }
        visitorButton.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(48)
            make.centerX.equalTo(self.view)
        }
        
    }
    
    // MARK: Sign in，登入後使用者將維持登入狀態，就算我們重新啟動 App ，使用者還是能保持登入
    @objc func signInButtonTouchUpInside() {
        
//        guard let userEmail = self.emailTextField.text else { return }
//        guard let userPassward = self.passwordTextField.text else { return }
        let userEmail = "beta@gmail.com"
        let userPassward = "222222"
        
        Auth.auth().signIn(withEmail: userEmail, password: userPassward) { result, error in
            guard error == nil else {
                print("登入失敗", error?.localizedDescription ?? "no error?.localizedDescription")
                self.errorLabel.text = "帳號或密碼有誤，請重新輸入"
                return
                
            }
            guard let userID = result?.user.uid else { return }
            currentUserUID = userID
            print("\(result?.user.uid ?? "") 登入成功")
            self.createTabBarController()
            
        }
        
    }
    
    // MARK: Sign up through programmer，建立帳號成功後使用者將是已登入狀態，下次重新啟動 App 也會是已登入狀態
    @objc func signUpButtonTouchUpInside() {
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { [self] result, error in
            guard let user = result?.user,
                  error == nil else {
                print("註冊失敗", error?.localizedDescription ?? "no error?.localizedDescription")
                return
            }
            
            currentUserUID = user.uid

            let userProfile = Users(userName: self.userNameTextField.text!, userPortrait: "BetaImageURL", location: ["latitude": 0.0, "longitude": 0.0])

            self.userProfileData = userProfile
            self.createUsers(userUID: user.uid)
            
            // ??
            DispatchQueue.main.async {
                self.createTabBarController()
            }
            
        }
        
    }
    
    // MARK: 訪客模式
    @objc func visitorButtonTouchUpInside() {
        
        createTabBarController()
        
    }
    
    // 新增使用者資料到 firebase
    private func createUsers(userUID: String) {
        guard let userProfileData else {
            print("userProfileData is nil.")
            return
        }
        
        // setData 會更新指定 documentID 的那個 document 的資料，如果沒有那個 collection 或 document id，則會新增
        database.collection("userTest").document(userUID).setData([
            // TODO: 這邊寫法為什麼不行
//            guard let self.userProfileData else {
//                print("userProfileData is nil.")
//                return
//            }
            
            "userName": userProfileData.userName,
            "userPortrait": userProfileData.userPortrait,
            "location": ["latitude": userProfileData.location["latitude"], "longitude": userProfileData.location["longitude"]]

        ])
        
    }
    
    func createTabBarController() {
        
        let customTabBarController = CustomTabBarController()

        present(customTabBarController, animated: true)
        
    }
    
}
