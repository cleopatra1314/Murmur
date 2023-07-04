//
//  SignUpNickNameViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/7/4.
//

import Foundation
import UIKit
import FirebaseAuth

class SignUpNickNameViewController: UIViewController {
    
    var userEmail: String?
    var userPassword: String?
    var userProfileData: Users?
    
    private let logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "BlueParrot.png")
        logoImageView.contentMode = .scaleAspectFit
        return logoImageView
    }()
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Create a Murmur Wall Account"
        titleLabel.textColor = .PrimaryMidDark
        titleLabel.textAlignment = .center
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
        ball2.backgroundColor = .PrimaryMiddle
        return ball2
    }()
    private let nickNameLabel: UILabel = {
        let nickNameLabel = UILabel()
        nickNameLabel.text = "角色暱稱"
        nickNameLabel.textColor = .SecondaryMiddle
        return nickNameLabel
    }()
    private let nickNameTextField: MessageTypeTextField = {
        let nickNameTextField = MessageTypeTextField()
        nickNameTextField.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        nickNameTextField.textColor = .SecondaryDark
        nickNameTextField.placeholder = "為自己取一個可愛的名字吧"
//        emailTextField.attributedPlaceholder = NSAttributedString(string: "請輸入 email", attributes: [
//            NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 18.0),
//            NSAttributedString.Key.kern: 1.5,
////            NSAttributedString.Key.foregroundColor: UIColor.green
//        ])
        nickNameTextField.layer.cornerRadius = 12
        nickNameTextField.backgroundColor = .GrayScale20?.withAlphaComponent(0.9)
        nickNameTextField.layer.addShineShadow()
        return nickNameTextField
    }()
    private let profilePicLabel: UILabel = {
        let profilePicLabel = UILabel()
        profilePicLabel.text = "大頭貼"
        profilePicLabel.textColor = .SecondaryMiddle
        return profilePicLabel
    }()
    let profilePicView: UIView = {
        let profilePicView = UIView()
        profilePicView.backgroundColor = .PrimaryDefault
        profilePicView.clipsToBounds = true
        return profilePicView
    }()
    lazy var profilePicImageView: UIImageView = {
        let profilePicImageView = UIImageView()
        profilePicImageView.image = UIImage(named: "User2Portrait.png")
        profilePicImageView.contentMode = .scaleAspectFill
        profilePicImageView.clipsToBounds = true
        return profilePicImageView
    }()
    private lazy var signUpWithEmailButton: UIButton = {
        let signUpWithEmailButton = UIButton()
        signUpWithEmailButton.setTitle("註冊", for: .normal)
        signUpWithEmailButton.setTitleColor(.GrayScale0, for: .normal)
        signUpWithEmailButton.backgroundColor = .SecondaryMiddle
        signUpWithEmailButton.layer.cornerRadius = 12
        signUpWithEmailButton.addTarget(self, action: #selector(signUpWithEmailButtonTouchUpInside), for: .touchUpInside)
        return signUpWithEmailButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.width / 2
        profilePicImageView.layer.borderColor = UIColor.lightGray.cgColor
        profilePicImageView.layer.borderWidth = 3
        profilePicView.layer.cornerRadius = profilePicView.frame.width / 2
        profilePicView.layer.borderColor = UIColor.lightGray.cgColor
        profilePicView.layer.borderWidth = 3
    }
    
    func createTabBarController() {
        
        let customTabBarController = CustomTabBarController()

        present(customTabBarController, animated: true)
        
    }
    
    // MARK: Sign up through programmer，建立帳號成功後使用者將是已登入狀態，下次重新啟動 App 也會是已登入狀態
    @objc func signUpWithEmailButtonTouchUpInside() {
        guard let userEmail else {
            print("userEmail is nil.")
            return
        }
        guard let userPassword else {
            print("userPassword is nil.")
            return
        }
        
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { [self] result, error in
            guard let user = result?.user,
                  error == nil else {
                print("註冊失敗", error?.localizedDescription ?? "no error?.localizedDescription")
                return
            }
            
            currentUserUID = user.uid

            let userProfile = Users(onlineState: true, userName: nickNameLabel.text!, userPortrait: "BetaImageURL", location: ["latitude": 0.0, "longitude": 0.0])

            self.userProfileData = userProfile
            self.createUsers(userUID: user.uid)
            
            // ??
            DispatchQueue.main.async {
                self.createTabBarController()
            }
            
        }
        
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
    
    func layoutView() {
        
        self.view.backgroundColor = .PrimaryLighter
        
        [logoImageView, titleLabel, stack, nickNameLabel, nickNameTextField, profilePicLabel, profilePicView, profilePicImageView, signUpWithEmailButton].forEach { subview in
            self.view.addSubview(subview)
        }
        
        [ball1, ball2].forEach { subview in
            stack.addArrangedSubview(subview)
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
        stack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalTo(self.view)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(nickNameTextField.snp.top).offset(-5)
            make.leading.equalTo(self.view).offset(30)
        }
        nickNameTextField.snp.makeConstraints { make in
            make.bottom.equalTo(profilePicLabel.snp.top).offset(-18)
            make.leading.equalTo(self.view).offset(30)
            make.trailing.equalTo(self.view).offset(-30)
            make.height.equalTo(43)
        }
        profilePicLabel.snp.makeConstraints { make in
            make.bottom.equalTo(profilePicView.snp.top).offset(-10)
            make.leading.equalTo(nickNameTextField)
        }
        profilePicView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.centerY).offset(-30)
            make.centerX.equalTo(self.view)
            make.height.width.equalTo(184)
        }
        profilePicImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.centerY).offset(-30)
            make.centerX.equalTo(self.view)
            make.height.width.equalTo(184)
        }
        signUpWithEmailButton.snp.makeConstraints { make in
            make.height.equalTo(39)
            make.width.equalTo(119)
            make.centerX.equalTo(self.view)
            make.top.equalTo(profilePicView.snp.bottom).offset(36)
        }
        
    }

    
}
