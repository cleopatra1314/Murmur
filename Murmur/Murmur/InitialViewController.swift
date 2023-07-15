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
import AuthenticationServices // Sign in with Apple 的主體框架
import CryptoKit // 用來產生隨機字串 (Nonce)

class InitialViewController: UIViewController {
    
    // MARK: - Sign in with Apple 登入
    fileprivate var currentNonce: String?
    
    // MARK: Lottie
    let pacmanAnimationView = LottieAnimationView(name: "Pacman")
    let logoMessageTypingAnimationView = LottieAnimationView(name: "LogoMessageTyping")
    
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
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Let’s murmur\nthe space"
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .ShadowLight
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "CaveatBrush-Regular", size: 38)
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
    let signInWithAppleButtonView = UIView()
    private let authorizationAppleIDButton: ASAuthorizationAppleIDButton = {
        let authorizationAppleIDButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
//        authorizationAppleIDButton.setTitle("Sign up with Apple", for: .normal)
//        authorizationAppleIDButton.setTitleColor(.GrayScale0, for: .normal)
//        authorizationAppleIDButton.backgroundColor = .SecondaryMiddle
        authorizationAppleIDButton.cornerRadius = 12
        authorizationAppleIDButton.layer.addWhiteShadow()
//        authorizationAppleIDButton.isHidden = true
        authorizationAppleIDButton.addTarget(self, action: #selector(signInWithAppleButtonTouchUpInside), for: .touchUpInside)
        authorizationAppleIDButton.addTarget(self, action: #selector(signUpWithAppleButtonTouchDown), for: .touchDown)
        return authorizationAppleIDButton
    }()
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
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
        signInButton.setTitleColor(.PrimaryMidDark, for: .normal)
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
            NSAttributedString.Key.kern: 1.5
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
        configureAppleSignInButton()
//        setSignUpWithAppleButton()
//        lottiePacman()
        lottieLogoMessageTyping()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setSignUpWithAppleButton() {
        
        authorizationAppleIDButton.frame = self.signInWithAppleButtonView.bounds
        self.signInWithAppleButtonView.addSubview(authorizationAppleIDButton)
        
    }
    
    /// 點擊 Sign In with Apple 按鈕後，請求授權
    @objc func signInWithAppleButtonTouchUpInside() {
        if #available(iOS 13.0, *) {
            let nonce = randomNonceString()
            currentNonce = nonce
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while(remainingLength > 0) {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if (errorCode != errSecSuccess) {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if (remainingLength == 0) {
                    return
                }

                if (random < charset.count) {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }
    
    @objc func signUpWithAppleButtonTouchDown() {// 点击改变背景色
        authorizationAppleIDButton.backgroundColor = UIColor.SecondarySaturate
    }
    
    @objc func signUpWithEmailButtonTouchDown() {// 点击改变背景色
        signUpWithEmailButton.backgroundColor = UIColor.SecondarySaturate
    }
    
    func lottiePacman() {
        pacmanAnimationView.play()
        pacmanAnimationView.loopMode = .loop
    }
    
    func lottieLogoMessageTyping() {
        logoMessageTypingAnimationView.play()
        logoMessageTypingAnimationView.loopMode = .loop
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
        [titleLabel, authorizationAppleIDButton, signUpWithEmailButton, stack, logoMessageTypingAnimationView].forEach { subview in
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
        authorizationAppleIDButton.snp.makeConstraints { make in
            make.top.equalTo(signUpWithEmailButton.snp.bottom).offset(14)
            make.leading.equalTo(mainView).offset(40)
            make.trailing.equalTo(mainView).offset(-40)
            make.height.equalTo(40)
            make.centerX.equalTo(mainView)
        }
        stack.snp.makeConstraints { make in
            make.top.equalTo(authorizationAppleIDButton.snp.bottom).offset(28)
            make.centerX.equalTo(mainView)
        }
        logoMessageTypingAnimationView.snp.makeConstraints { make in
            make.top.equalTo(mainView).offset(40)
            make.width.height.equalTo(52)
            make.centerX.equalTo(mainView)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoMessageTypingAnimationView.snp.bottom).offset(4)
            make.centerX.equalTo(mainView)
        }
        
        noteLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(stack)
            make.trailing.equalTo(signInButton.snp.leading).offset(-4)
        }
        signInButton.snp.makeConstraints { make in
            make.top.trailing.bottom.equalTo(stack)
        }
//        pacmanAnimationView.snp.makeConstraints { make in
//            make.height.width.equalTo(180)
//            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-40)
//            make.centerX.equalTo(self.view)
//        }
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
    
//    func createTabBarController() {
//
//        let customTabBarController = CustomTabBarController()
//
//        present(customTabBarController, animated: true)
//
//    }
    
    // 由於 apple ID 登入只支援iOS 13 以上的版本，故需控制按鈕是否可使用
    func configureAppleSignInButton() {
        if #available(iOS 13.0, *) {
            signUpWithEmailButton.isHidden = false
        } else {
            signUpWithEmailButton.isHidden = true
        }
    }
    
}

extension InitialViewController {
    // MARK: - 透過 Credential 與 Firebase Auth 串接
    func firebaseSignInWithApple(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { authResult, error in
            guard error == nil else {
                self.showAlert(title: "", message: String(describing: error!.localizedDescription), viewController: self)
                return
            }
            
            let alertController = UIAlertController(title: "登入成功！", message: "開始 murmur", preferredStyle: .alert)
            
            // 加入確定的動作。
            let okAction = UIAlertAction(title: "確定", style: .default) { alertAction in
                self.createTabBarController()
            }
        
        }
    }
    
    // MARK: - Firebase 取得登入使用者的資訊
    func getFirebaseUserInfo() {
        let currentUser = Auth.auth().currentUser
        guard let user = currentUser else {
            self.showAlert(title: "無法取得使用者資料！", message: "", viewController: self)
            return
        }
        let uid = user.uid
        let email = user.email
        self.showAlert(title: "使用者資訊", message: "UID：\(uid)\nEmail：\(email!)", viewController: self)
    }
}

extension InitialViewController: ASAuthorizationControllerDelegate {
    
    @available(iOS 13.0, *)
    /// 授權成功
    /// - Parameters:
    ///   - controller: _
    ///   - authorization: _
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        
//        switch authorization.credential {
//
//        case let appleIDCredential as ASAuthorizationAppleIDCredential:
//            let userIdentifier = appleIDCredential.user
//            guard let authorizationCode = appleIDCredential.authorizationCode else { return }
//            guard let authorizationCodeString = String(data: authorizationCode, encoding: .utf8) else { return }
//            guard let identifierToken = appleIDCredential.identityToken else { return }
//            guard let identifierTokenString = String(data: identifierToken, encoding: .utf8) else { return }
//
//            // TODO:
//            print("user: \(appleIDCredential.user)")
//            print("fullName: \(String(describing: appleIDCredential.fullName))")
//            print("Email: \(String(describing: appleIDCredential.email))")
//            print("realUserStatus: \(String(describing: appleIDCredential.realUserStatus))")
//
//            userProfileData?.id = appleIDCredential.user
//            userProfileData?.userName = String(describing: appleIDCredential.fullName)
//            userProfileData?.onlineState = true
//
//        default:
//            break
//
//        }
        
        // 登入成功
                if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                    guard let nonce = currentNonce else {
                        fatalError("Invalid state: A login callback was received, but no login request was sent.")
                    }
                    guard let appleIDToken = appleIDCredential.identityToken else {
                        self.showAlert(title: "", message: "Unable to fetch identity token", viewController: self)
                        return
                    }
                    guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                        self.showAlert(title: "", message: "Unable to fetch identity token", viewController: self)
                        return
                    }
                    // 產生 Apple ID 登入的 Credential
                    let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
                    // 與 Firebase Auth 進行串接
                    firebaseSignInWithApple(credential: credential)
                }
        
    }
    
    /// 授權失敗
    /// - Parameters:
    ///   - controller: _
    ///   - error: _
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
                
        switch (error) {
        case ASAuthorizationError.canceled:
            showAlert(title: "使用者取消登入", message: "\(error.localizedDescription)", viewController: self)
            break
        case ASAuthorizationError.failed:
            showAlert(title: "授權請求失敗", message: "\(error.localizedDescription)", viewController: self)
            break
        case ASAuthorizationError.invalidResponse:
            showAlert(title: "授權請求無回應", message: "\(error.localizedDescription)", viewController: self)
            break
        case ASAuthorizationError.notHandled:
            showAlert(title: "授權請求未處理", message: "\(error.localizedDescription)", viewController: self)
            break
        case ASAuthorizationError.unknown:
            showAlert(title: "授權失敗，原因不知", message: "\(error.localizedDescription)", viewController: self)
            break
        default:
            break
        }
                    
        print("didCompleteWithError: \(error.localizedDescription)")
    }
}

extension InitialViewController : ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
    
}
