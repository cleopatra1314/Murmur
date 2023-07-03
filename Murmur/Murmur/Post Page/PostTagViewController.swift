//
//  PostTagViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/18.
//

import Foundation
import UIKit
import FirebaseFirestore

class PostTagViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "About your murmur"
        return titleLabel
    }()
//    private let selectedTagStack: UICollectionView = {
//        let selectedTagStack = UICollectionView()
//        return selectedTagStack
//    }()
    private let numberOfTagLabel: UILabel = {
        let numberOfTagLabel = UILabel()
        numberOfTagLabel.text = "4 of 5"
        return numberOfTagLabel
    }()
//    private let allTagStack: UICollectionView = {
//        let allTagStack = UICollectionView()
//        return allTagStack
//    }()
    var murmurData: [String: Any] = [
        "userUID": currentUserUID,
//        "location": ["latitude": nil, "longitude": nil],
        "location": [String: Double](),
        "murmurMessage": [String](),
        "murmurImage": "png",
        "selectedTags": [String](),
        "createTime": Timestamp(date: Date())
        ]
    
    let database = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .PrimaryLight
        setNav()
 
    }
    
    private func setNav() {
//        let navigationController = UINavigationController(rootViewController: self)
//        navigationController.modalPresentationStyle = .fullScreen
//        navigationController.navigationBar.barStyle = .default
//        navigationController.navigationBar.backgroundColor = .blue
        
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.title = "塗鴉標籤"
        
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonItemTouchUpInside))
        backButtonItem.tintColor = .SecondaryShine
        navigationItem.leftBarButtonItem = backButtonItem
        
        let postButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(postButtonItemTouchUpInside))
        postButtonItem.setTitleTextAttributes([NSAttributedString.Key.kern: 0, .font: UIFont.systemFont(ofSize: 18, weight: .medium)], for: .normal)
        postButtonItem.tintColor = .white
        navigationItem.rightBarButtonItem = postButtonItem
    }
    
    @objc func backButtonItemTouchUpInside() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func postButtonItemTouchUpInside() {
//        錯誤寫法
//        self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
//        self.navigationController?.popToViewController((self.tabBarController?.viewControllers![0])!, animated: true)
//        present((self.tabBarController?.viewControllers![0])!, animated: true)
        
        // Create data to firebase: 目前所在座標、塗鴉留言、照片、3個 selected tags、用戶id
        let homeVC = self.tabBarController?.viewControllers![0] as? HomePageViewController
        homeVC?.switchModeButton.setImage(UIImage(named: "Icons_People"), for: .normal)
        homeVC?.nearbyUsersContainerView.isHidden = true
        homeVC?.locationMessageContainerView.isHidden = false
        homeVC?.switchMode = true
        
//        let postVC = self.navigationController?.viewControllers[0] as? PostViewController
//        postVC!.sendMurmurMessageClosure = { [self] murmurMessage in
//            self.murmurData["murmurMessage"] = murmurMessage
//        }
        
        // 将 location 强制转换为 [String: Double] 类型
        if var location = murmurData["location"] as? [String: Double] {
            location["latitude"] = currentCoordinate?.latitude
            location["longitude"] = currentCoordinate?.longitude
            murmurData["location"] = location
        }
        print("上傳的位置資料", murmurData["location"]!, currentCoordinate)

        createMurmur()
        
        let postVC = self.navigationController?.popViewController as? PostViewController
        print("上一頁輸入的文字為", postVC?.murmurTextField.text)
        postVC?.murmurTextField.text = ""
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    func createMurmur() {
        
        // 在總 murmurTest 新增資料
        let documentReference = database.collection("murmurTest").document()
        documentReference.setData(murmurData)
        
        // 在目前用戶的 postedMurmur 新增資料
        database.collection("userTest").document(currentUserUID).collection("postedMurmurs").document(documentReference.documentID).setData(murmurData)
        
//        do {
//            try db.collection("murmurTest").document("很久很久").setData(murmurData)
//        } catch {
//            print(error)
//        }
//        print(documentReference.documentID)
    }
    
}
