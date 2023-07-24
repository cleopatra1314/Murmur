//
//  SettingViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/30.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices // Sign in with Apple 的主體框架
import CryptoKit // 用來產生隨機字串 (Nonce)

class SettingViewController: UIViewController {
    
    var user: User?
    fileprivate var currentNonce: String?
    
    lazy var signOutButton: UIButton = {
        let signOutButton = UIButton()
        signOutButton.frame = CGRect(x: 150, y: 200, width: 120, height: 40)
        signOutButton.backgroundColor = .GrayScale20
        signOutButton.layer.borderColor = UIColor.ErrorMidDark?.cgColor
        signOutButton.layer.borderWidth = 1
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.setTitleColor(.ErrorMidDark, for: .normal)
        signOutButton.layer.cornerRadius = 10
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return signOutButton
    }()
    lazy var deleteAccountButton: UIButton = {
        let deleteAccountButton = UIButton()
        deleteAccountButton.frame = CGRect(x: 150, y: 260, width: 120, height: 40)
        deleteAccountButton.backgroundColor = .ErrorMidDark
        deleteAccountButton.setTitle("Delete Account", for: .normal)
        deleteAccountButton.layer.cornerRadius = 10
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTouchUpInside), for: .touchUpInside)
        return deleteAccountButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .SecondaryLight
        layoutView()
        
    }
    
    func layoutView() {
        
        self.view.addSubview(signOutButton)
        self.view.addSubview(deleteAccountButton)
        
        signOutButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(72)
            make.trailing.equalTo(self.view.snp.centerX).offset(-8)
            make.height.equalTo(40)
            make.width.equalTo(120)
        }
        deleteAccountButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(72)
            make.leading.equalTo(self.view.snp.centerX).offset(8)
            make.height.equalTo(40)
            make.width.equalTo(120)
        }
        
    }
    
    // use the ID token from Apple's response to create a Firebase AuthCredential object
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
    
    private func deleteCurrentUser() {
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

    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
      guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential
      else {
        print("Unable to retrieve AppleIDCredential")
        return
      }

      guard let _ = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }

      guard let appleAuthCode = appleIDCredential.authorizationCode else {
        print("Unable to fetch authorization code")
        return
      }

      guard let authCodeString = String(data: appleAuthCode, encoding: .utf8) else {
        print("Unable to serialize auth code string from data: \(appleAuthCode.debugDescription)")
        return
      }

//      Task {
//        do {
//          try await Auth.auth().revokeToken(withAuthorizationCode: authCodeString)
//          try await user?.delete()
//          self.updateUI()
//        } catch {
//          self.displayError(error)
//        }
//      }
        
    }

    
    @objc func deleteAccountButtonTouchUpInside() {
        
        // 創造一個 UIAlertController 的實例。
        let alertController = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete your Murmur Wall acount? This action cannot be undone.", preferredStyle: .alert)
        
        // 加入確定的動作。
        let okAction = UIAlertAction(title: "Delete", style: .default) { alertAction in
            
            let user = Auth.auth().currentUser

            user?.delete { error in
                if let error = error {
                    print("Error: Account delete failed.", error)
                } else {
                    // 刪除 chatRooms 底下 documents
                    database.collection("userTest").document(currentUserUID).collection("chatRooms").getDocuments { querySnapshot, error in
                        
                        if let error = error {
                                    print("Error getting documents: \(error)")
                                } else {
                                    for document in querySnapshot!.documents {
                                        document.reference.delete()
                                    }
                                }
                    }
                  
                    // 刪除 postedMurmurs 底下 documents
                    database.collection("userTest").document(currentUserUID).collection("postedMurmurs").getDocuments { querySnapshot, error in
                        
                        if let error = error {
                                    print("Error getting documents: \(error)")
                                } else {
                                    for document in querySnapshot!.documents {
                                        document.reference.delete()
                                    }
                                }
                    }
                  
                    // 刪除 userID collection
                    database.collection("userTest").document(currentUserUID).delete()
                    
                    let initialVC = InitialViewController()
                    let initialNavigationController = CustomNavigationController(rootViewController: initialVC)
                    self.view.window?.rootViewController = initialNavigationController
                    
                    self.view.window?.rootViewController?.dismiss(animated: true)
                    
                    self.navigationController?.popToRootViewController(animated: true)
                    
              }
            }
            
        }
        alertController.addAction(okAction)
        
        // 加入取消的動作。
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { alertAction in
            return
        }
        alertController.addAction(cancelAction)
        
        // 呈現 alertController。
        present(alertController, animated: true)
        
    }
    
    @objc func signOut() {
        
//        do {
//            try Auth.auth().signOut()
//            showAlert(title: "登出成功", message: "請再次登入才能享有各式功能哦！", viewController: self)
//
//            database.collection("userTest").document(currentUserUID).setData([
//                "onlineState": false
//            ], merge: true)
//
//            print("登出成功")
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
        
        // 創造一個 UIAlertController 的實例。
        let alertController = UIAlertController(title: "Are you sure?", message: "Do you really want to sign out? We'll miss you.", preferredStyle: .alert)
        
        // 加入確定的動作。
        let okAction = UIAlertAction(title: "Sign out", style: .default) { alertAction in
            
            do {
                try Auth.auth().signOut()
            
                database.collection("userTest").document(currentUserUID).setData([
                    "onlineState": false
                ], merge: true)
                                
                //                    // 等到上面的 firebase 資料都刪除後再來 present
//                                    let initialVC = InitialViewController()
                //                    initialVC.modalPresentationStyle = .fullScreen
                //                    initialVC.modalTransitionStyle = .crossDissolve
                //                    self.present(initialVC, animated: true)
//                                    self.view.window?.rootViewController = initialVC
                //                    self.navigationController?.popToRootViewController(animated: true)
                let initialVC = InitialViewController()
                let initialNavigationController = CustomNavigationController(rootViewController: initialVC)
                self.view.window?.rootViewController = initialNavigationController
                
                self.view.window?.rootViewController?.dismiss(animated: true)
                
                self.navigationController?.popToRootViewController(animated: true)
                
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        alertController.addAction(okAction)
        
        // 加入取消的動作。
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { alertAction in
            return
        }
        alertController.addAction(cancelAction)
        
        // 呈現 alertController。
        present(alertController, animated: true)
        
    }
    
    func confirmSignOutAlert(message: String, viewController: UIViewController) {
        // 創造一個 UIAlertController 的實例。
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        // 加入確定的動作。
        let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        // 加入取消的動作。
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        alertController.addAction(cancelAction)
        
        // 呈現 alertController。
        viewController.present(alertController, animated: true)
    }
    
}

extension SettingViewController: ASAuthorizationControllerDelegate {
    
}

extension SettingViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
    
    
}
