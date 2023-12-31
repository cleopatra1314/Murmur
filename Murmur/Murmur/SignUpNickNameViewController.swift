//
//  SignUpNickNameViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/7/4.
//

import Foundation
import UIKit
import FirebaseAuth
import Lottie

class SignUpNickNameViewController: UIViewController {
    
    let logoMessageTypingAnimationView = LottieAnimationView(name: "LogoMessageTyping")
    
    var userEmail: String?
    var userPassword: String?
    var userProfileData: Users?
    var capturedPortraitImage: UIImage?
    
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
//        ball1.frame = CGRect(x: 0, y: 0, width: 8, height: 8)
        ball1.layer.cornerRadius = 4
        ball1.backgroundColor = .PrimaryMiddle
        return ball1
    }()
    private let ball2: UIView = {
        let ball2 = UIView()
//        ball2.frame = CGRect(x: 0, y: 0, width: 8, height: 8)
        ball2.layer.cornerRadius = 4
        ball2.backgroundColor = .PrimaryMiddle
        return ball2
    }()
    private let nickNameLabel: UILabel = {
        let nickNameLabel = UILabel()
        nickNameLabel.text = "Nickname"
        nickNameLabel.textColor = .SecondarySaturate
        return nickNameLabel
    }()
    private let nickNameTextField: MessageTypeTextField = {
        let nickNameTextField = MessageTypeTextField()
        nickNameTextField.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        nickNameTextField.textColor = .SecondaryDark
        nickNameTextField.placeholder = "Get a lovely name"
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
        profilePicLabel.text = "Profile photo"
        profilePicLabel.textColor = .SecondarySaturate
        return profilePicLabel
    }()
    private lazy var captureButton: UIButton = {
        let captureButton = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        captureButton.setImage(UIImage(named: "Icons_Capture.png"), for: .normal)
        captureButton.tintColor = .GrayScale60
        captureButton.addTarget(self, action: #selector(captureButtonTouchUpInside), for: .touchUpInside)
        return captureButton
    }()
    let profilePicView: UIView = {
        let profilePicView = UIView()
        profilePicView.backgroundColor = .PrimaryDefault?.withAlphaComponent(1)
        profilePicView.clipsToBounds = true
        return profilePicView
    }()
    lazy var profilePicImageView: UIImageView = {
        let profilePicImageView = UIImageView()
//        profilePicImageView.image = UIImage(named: "User2Portrait.png")
        profilePicImageView.contentMode = .scaleAspectFill
        profilePicImageView.clipsToBounds = true
        return profilePicImageView
    }()
    private lazy var trashButton: UIButton = {
        let trashButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        trashButton.setImage(UIImage(named: "Icons_Trash.png"), for: .normal)
        trashButton.addTarget(self, action: #selector(trashButtonTouchUpInside), for: .touchUpInside)
        trashButton.tintColor = .ErrorMidDark
        return trashButton
    }()
    private lazy var signUpWithEmailButton: UIButton = {
        let signUpWithEmailButton = UIButton()
        signUpWithEmailButton.setTitle("Sign Up", for: .normal)
        signUpWithEmailButton.setTitleColor(.GrayScale20, for: .normal)
        signUpWithEmailButton.titleLabel?.font = UIFont(name: "PingFangTC-Medium", size: 16)
        signUpWithEmailButton.backgroundColor = .SecondaryMiddle
        signUpWithEmailButton.layer.cornerRadius = 12
        signUpWithEmailButton.addTarget(self, action: #selector(signUpWithEmailButtonTouchUpInside), for: .touchUpInside)
        signUpWithEmailButton.addTarget(self, action: #selector(signUpWithEmailButtonTouchDown), for: .touchDown)
        return signUpWithEmailButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutView()
        lottieLogoMessageTyping()
        
        trashButton.isHidden = true
        
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
        profilePicView.layer.borderColor = UIColor.GrayScale60?.cgColor
        profilePicView.layer.borderWidth = 3
    }
    
    func lottieLogoMessageTyping() {
        logoMessageTypingAnimationView.play()
        logoMessageTypingAnimationView.loopMode = .loop
    }
    
    @objc func signUpWithEmailButtonTouchDown() {// 点击改变背景色
        signUpWithEmailButton.backgroundColor = UIColor.SecondarySaturate
    }
    
    @objc func captureButtonTouchUpInside() {
        
        // 建立一個 UIImagePickerController 的實體
        let imagePickerController = UIImagePickerController()

        // 委任代理
        imagePickerController.delegate = self

        // 建立一個 UIAlertController 的實體
        // 設定 UIAlertController 的標題與樣式為 動作清單 (actionSheet)
        let imagePickerAlertController = UIAlertController(title: "Upload Image", message: "Select an Image", preferredStyle: .actionSheet)

        // 建立三個 UIAlertAction 的實體
        // 新增 UIAlertAction 在 UIAlertController actionSheet 的 動作 (action) 與標題
        let imageFromLibAction = UIAlertAction(title: "Album", style: .default) { (void) in

            // 判斷是否可以從照片圖庫取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {

                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.photoLibrary)，並 present UIImagePickerController
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        let imageFromCameraAction = UIAlertAction(title: "Camera", style: .default) { (void) in

            // 判斷是否可以從相機取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.camera) {

                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.camera)，並 present UIImagePickerController
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }

        // 新增一個取消動作，讓使用者可以跳出 UIAlertController
        let cancelAction = UIAlertAction(title: "Canecl", style: .cancel) { (void) in

            imagePickerAlertController.dismiss(animated: true, completion: nil)
        }

        // 將上面三個 UIAlertAction 動作加入 UIAlertController
        imagePickerAlertController.addAction(imageFromLibAction)
        imagePickerAlertController.addAction(imageFromCameraAction)
        imagePickerAlertController.addAction(cancelAction)

        // 當使用者按下 uploadBtnAction 時會 present 剛剛建立好的三個 UIAlertAction 動作與
        present(imagePickerAlertController, animated: true, completion: nil)
        
    }
    
    @objc func trashButtonTouchUpInside() {
        profilePicView.isHidden = false
        profilePicImageView.isHidden = true
        captureButton.isHidden = false
        captureButton.isEnabled = true
    }
    
    // MARK: Sign up，建立帳號成功後使用者將是已登入狀態，下次重新啟動 App 也會是已登入狀態
    @objc func signUpWithEmailButtonTouchUpInside() {
        guard let userEmail else {
            
            print("userEmail is nil.")
            return
        }
        guard let userPassword else {
            print("userPassword is nil.")
            return
        }
        guard let nickName = nickNameTextField.text else {
            print("nickName is nil.")
            return
        }

        
        
        uploadPhoto(image: capturedPortraitImage) { [self] result in
            switch result {
                
            case .success(let url):
                
                // url 轉 string
                let selectedImageUrlString = url.absoluteString
                
                self.userProfileData?.userPortrait = selectedImageUrlString
                
                // 創建 auth 會員
                Auth.auth().createUser(withEmail: userEmail, password: userPassword) { [self] result, error in
                    guard let user = result?.user,
                          error == nil else {
                        print("註冊失敗", error?.localizedDescription ?? "no error?.localizedDescription")
                        return
                    }
                    
                    currentUserUID = user.uid

                    let userProfile = Users(onlineState: true, userName: nickName, userPortrait: selectedImageUrlString, location: ["latitude": 0.0, "longitude": 0.0])

                    self.userProfileData = userProfile
                    self.createUsers(userUID: user.uid)
                    
                    // TODO: ??
                    DispatchQueue.main.async {
                        self.createTabBarController()
                    }
                    
                }
                
            case .failure(let error):
                print(error)
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

            "onlineState": userProfileData.onlineState,
            "userName": userProfileData.userName,
            "userPortrait": userProfileData.userPortrait,
            "location": ["latitude": userProfileData.location["latitude"], "longitude": userProfileData.location["longitude"]]

        ])
        
    }
    
    func layoutView() {
        
        self.view.backgroundColor = .PrimaryLighter
        
        [logoMessageTypingAnimationView, titleLabel, stack, nickNameLabel, nickNameTextField, profilePicLabel, profilePicView, profilePicImageView, captureButton, trashButton, signUpWithEmailButton].forEach { subview in
            self.view.addSubview(subview)
        }
        
        [ball1, ball2].forEach { subview in
            stack.addArrangedSubview(subview)
        }
        
        ball1.snp.makeConstraints { make in
            make.height.width.equalTo(8)
        }
        
        ball2.snp.makeConstraints { make in
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
        captureButton.snp.makeConstraints { make in
            make.center.equalTo(profilePicView)
            make.height.width.equalTo(72)
        }
        profilePicImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.centerY).offset(-30)
            make.centerX.equalTo(self.view)
            make.height.width.equalTo(184)
        }
        trashButton.snp.makeConstraints { make in
            make.bottom.equalTo(profilePicView).offset(-6)
            make.leading.equalTo(profilePicView.snp.trailing)
            make.height.width.equalTo(28)
        }
        signUpWithEmailButton.snp.makeConstraints { make in
            make.height.equalTo(39)
            make.width.equalTo(119)
            make.centerX.equalTo(self.view)
            make.top.equalTo(profilePicView.snp.bottom).offset(36)
        }
        
    }

}

extension SignUpNickNameViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // [String : Any]
        
        var selectedImageFromPicker: UIImage?
        
        // 取得從 UIImagePickerController 選擇的檔案
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//
//            selectedImageFromPicker = pickedImage
//        }
        
        // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
        let uniqueString = NSUUID().uuidString
        
        // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
//        if let selectedImage = selectedImageFromPicker {
//
//            print("\(uniqueString), \(selectedImage)")
//        }
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // 在此處理選取的照片
            profilePicImageView.image = selectedImage
            self.capturedPortraitImage = selectedImage
            
            profilePicImageView.isHidden = false
            profilePicView.isHidden = true
            captureButton.isHidden = true
            captureButton.isEnabled = false
            trashButton.isHidden = false
            
        }
        
        dismiss(animated: true, completion: nil)
    }
}
