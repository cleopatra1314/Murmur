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
import Lottie

class InitialViewController: UIViewController {
    
    // MARK: Lottie
    let pacmanAnimationView = LottieAnimationView(name: "Pacman")
    
    private let backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "BackgroundVaporWaveCrop1.png")
        return backgroundImageView
    }()
    private let mainView: UIView = {
        let mainView = UIView()
        mainView.backgroundColor = .PrimaryLighter
        mainView.layer.cornerRadius = 90
        mainView.layer.addSaturatedShadow1()
        return mainView
    }()
    private let logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "BlueParrot.png")
        logoImageView.contentMode = .scaleAspectFit
        return logoImageView
    }()
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Let’s murmur the space."
        titleLabel.textColor = .PrimaryMidDark
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    private lazy var signUpWithEmailButton: UIButton = {
        let signUpWithEmailButton = UIButton()
        signUpWithEmailButton.setTitle("Sign up with Email", for: .normal)
        signUpWithEmailButton.setTitleColor(.GrayScale0, for: .normal)
        signUpWithEmailButton.backgroundColor = .SecondaryMiddle
        signUpWithEmailButton.layer.cornerRadius = 12
        signUpWithEmailButton.addTarget(self, action: #selector(signUpWithEmailButtonTouchUpInside), for: .touchUpInside)
        signUpWithEmailButton.addTarget(self, action: #selector(signUpWithEmailButtonTouchDown), for: .touchDown)
        signUpWithEmailButton.layer.addWhiteShadow()
        return signUpWithEmailButton
    }()
    private let signUpWithAppleButton: UIButton = {
        let signUpWithAppleButton = UIButton()
        signUpWithAppleButton.setTitle("Sign up with Apple", for: .normal)
        signUpWithAppleButton.setTitleColor(.GrayScale0, for: .normal)
        signUpWithAppleButton.backgroundColor = .SecondaryMiddle
        signUpWithAppleButton.layer.cornerRadius = 12
        signUpWithAppleButton.layer.addWhiteShadow()
        return signUpWithAppleButton
    }()
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    private let noteLabel: UILabel = {
        let noteLabel = UILabel()
        noteLabel.text = "Already have an account ?"
        noteLabel.textColor = .SecondaryDark
        return noteLabel
    }()
    private lazy var signInButton: UIButton = {
        let signInButton = UIButton()
        signInButton.frame = CGRect(x: 0, y: 0, width: 46, height: 20)
        signInButton.setTitle("Sign in", for: .normal)
        signInButton.setTitleColor(.PrimaryMiddle, for: .normal)
        signInButton.addTarget(self, action: #selector(signInButtonTouchUpInside), for: .touchUpInside)
        return signInButton
    }()
    
    //--------------------------
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
//    private lazy var signInButton: UIButton = {
//        let signInButton = UIButton()
//        signInButton.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
////        signInButton.backgroundColor = .black
//        signInButton.setTitle("Sign In", for: .normal)
//        signInButton.addTarget(self, action: #selector(signInButtonTouchUpInside), for: .touchUpInside)
//        return signInButton
//    }()
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
        
        layoutBackground()
        layoutView()
        lottiePacman()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func signUpWithEmailButtonTouchDown() {// 点击改变背景色
        signUpWithEmailButton.backgroundColor = UIColor.SecondarySaturate
    }
    
    func lottiePacman() {
        pacmanAnimationView.play()
        pacmanAnimationView.loopMode = .loop
    }
    
    @objc func signUpWithEmailButtonTouchUpInside() {
        signUpWithEmailButton.backgroundColor = .SecondaryMiddle
        let signUpEmailVC = SignUpEmailViewController()
        self.navigationController?.pushViewController(signUpEmailVC, animated: true)
        
    }
    
    @objc func signInButtonTouchUpInside() {
        
        let signInVC = SignInViewController()
        self.navigationController?.pushViewController(signInVC, animated: true)
        
    }
    
    func layoutBackground() {
        [backgroundImageView, mainView].forEach { subview in
            self.view.addSubview(subview)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        mainView.snp.makeConstraints { make in
            make.height.equalTo(self.view).multipliedBy(0.88)
            make.leading.trailing.bottom.equalTo(self.view)
        }
    }
    
    func layoutView() {
        [logoImageView, titleLabel, signUpWithAppleButton, signUpWithEmailButton, stack, pacmanAnimationView].forEach { subview in
            mainView.addSubview(subview)
        }
        
        [noteLabel, signInButton].forEach { subview in
            stack.addSubview(subview)
        }
        
        signUpWithEmailButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.snp.centerY)
            make.leading.equalTo(mainView).offset(40)
            make.trailing.equalTo(mainView).offset(-40)
            make.height.equalTo(40)
            make.centerX.equalTo(mainView)
        }
        signUpWithAppleButton.snp.makeConstraints { make in
            make.top.equalTo(signUpWithEmailButton.snp.bottom).offset(14)
            make.leading.equalTo(mainView).offset(40)
            make.trailing.equalTo(mainView).offset(-40)
            make.height.equalTo(40)
            make.centerX.equalTo(mainView)
        }
        stack.snp.makeConstraints { make in
            make.top.equalTo(signUpWithAppleButton.snp.bottom).offset(28)
            make.centerX.equalTo(mainView)
        }
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(mainView).offset(40)
            make.width.equalTo(80)
            make.centerX.equalTo(mainView)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(18)
            make.centerX.equalTo(mainView)
        }
        
        noteLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(stack)
            make.trailing.equalTo(signInButton.snp.leading).offset(-4)
        }
        signInButton.snp.makeConstraints { make in
            make.top.trailing.bottom.equalTo(stack)
        }
        pacmanAnimationView.snp.makeConstraints { make in
            make.height.width.equalTo(180)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-40)
            make.centerX.equalTo(self.view)
        }
    }
    
    // MARK: Sign in，登入後使用者將維持登入狀態，就算我們重新啟動 App ，使用者還是能保持登入
    @objc func signInButtonTouchUpInside1() {
        
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

            let userProfile = Users(onlineState: true, userName: self.userNameTextField.text!, userPortrait: "BetaImageURL", location: ["latitude": 0.0, "longitude": 0.0])

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
            
            "onlineState": userProfileData.onlineState,
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
