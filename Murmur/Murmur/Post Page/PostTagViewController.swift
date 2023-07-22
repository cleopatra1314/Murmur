//
//  PostTagViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/18.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage
import SnapKit

class PostTagViewController: UIViewController {
    
    var MWtagArray = ["🍜 Food","🎨 Art", "👾 Pet", "🧍🏻‍♀️ Her", "🧍🏻‍♂️ Him", "☕️ Coffee", "❓ Mystery", "🥳 Happy", "😠 Angry", "🥲 Sad", "😖 Anxious", "🥱 Tired", "🤔 Mood", "🏳️‍🌈 LGBTQ", "🚶🏻‍♀️ Nomad", "🌲 Plant", "🧗 Climbing", "🥾 Hiking", "🛣️ Road-Trip", "🏍️ Motorcycle", "🛍️ Shopping", "😆 Entertainment", "👩🏻‍🤝‍👨🏼 Friends", "🥨 Philodophy", "🧋 Drinks", "🍿 Movies", "🍰 Desserts", "🧳 Travel", "🏘️ City", "🏯 Temple", "🗣️ Politics", "💒 Religion", "🔴 Red", "🟠 Orange", "🔵 Blue", "🟡 Yellow", "🟢 Green", "🟣 Purple", "⚪️ White", "⚫️ Black"] {
        didSet {
            postTagCollectionView.reloadData()
        }
    }
    var selectedTagArray = ["🚥 Street"] {
        didSet {
            postTagCollectionView.reloadData()
        }
    }
    
    var uploadImage: UIImage?

//    private let titleLabel: UILabel = {
//        let titleLabel = UILabel()
//        return titleLabel
//    }()
//    private let selectedTagStack: UICollectionView = {
//        let selectedTagStack = UICollectionView()
//        return selectedTagStack
//    }()
//    private let numberOfTagLabel: UILabel = {
//        let numberOfTagLabel = UILabel()
//        return numberOfTagLabel
//    }()
    lazy var postTagCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
        let layout = TagCollectionViewFlowLayout()
        // section 的間距
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        // 每行 cell 間距
        layout.minimumLineSpacing = 12
        // cell 之間間距
        layout.minimumInteritemSpacing = 8
        // cell 長寬
        //        layout.itemSize = CGSize(width: 100, height: 30)
        // 滑動的方向
        layout.scrollDirection = .vertical
        // 以 auto layout 計算 cell 大小
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        // collectionView frame設定 x,y,寬,高
        let postTagCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        // 背景顏色
        postTagCollectionView.backgroundColor = .PrimaryLighter
        // items 靠右
//        postTagCollectionView.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
//        layout.headerReferenceSize = CGSize(width: 0, height: 180)
        layout.sectionHeadersPinToVisibleBounds = false
        
        // 你所註冊的cell
        postTagCollectionView.register(PostTagCollectionReusableHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(PostTagCollectionReusableHeaderView.self)")
        postTagCollectionView.register(PostTagCollectionReusableFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "\(PostTagCollectionReusableFooterView.self)")
        postTagCollectionView.register(SelectedTagCollectionViewCell.self, forCellWithReuseIdentifier: "\(SelectedTagCollectionViewCell.self)")
        postTagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "\(TagCollectionViewCell.self)")
        
        postTagCollectionView.delegate = self
        postTagCollectionView.dataSource = self
        
        return postTagCollectionView
    }()
    var murmurData: [String: Any] = [
        "userUID": currentUserUID,
//        "location": ["latitude": nil, "longitude": nil],
        "location": [String: Double](),
        "murmurMessage": [String](),
        "murmurImage": String(),
        "selectedTags": [String](),
        "createTime": Timestamp(date: Date())
        ]
    lazy var postButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(postButtonItemTouchUpInside))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postButtonItem.isEnabled = true
        
        self.view.backgroundColor = .PrimaryLight
        setNav()
        layoutView()

    }

    func layoutView() {
        
        self.view.addSubview(postTagCollectionView)
        postTagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalTo(self.view)
        }
        
    }

    private func setNav() {

        self.navigationItem.title = "塗鴉標籤"
        
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonItemTouchUpInside))
        backButtonItem.tintColor = .SecondaryShine
        navigationItem.leftBarButtonItem = backButtonItem
        
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
        postButtonItem.isEnabled = false
        
        guard let postVC = self.navigationController?.viewControllers.first as? PostViewController else {
            print("Error: self.navigationController?.viewControllers.first can't transform to PostViewController")
            return
        }
        postVC.murmurTextField.text = ""
        postVC.murmurView.isHidden = false
        postVC.murmurImageView.isHidden = true
        postVC.captureButton.isEnabled = true
        
        // Create data to firebase: 目前所在座標、塗鴉留言、照片、3個 selected tags、用戶id
        let homeVC = self.tabBarController?.viewControllers![0] as? HomePageViewController
        homeVC?.switchModeButton.setImage(UIImage(named: "Icons_People"), for: .normal)
        homeVC?.nearbyUsersContainerView.isHidden = true
        homeVC?.locationMessageContainerView.isHidden = false
        homeVC?.switchMode = true

        // 将 location 强制转换为 [String: Double] 类型
        if var location = murmurData["location"] as? [String: Double] {
            location["latitude"] = currentCoordinate?.latitude
            location["longitude"] = currentCoordinate?.longitude
            murmurData["location"] = location
        }

        uploadPhoto(image: uploadImage) { [self] result in
            switch result {
            case .success(let url):
                
                let selectedImageUrlString = url.absoluteString
                
                murmurData["murmurImage"] = selectedImageUrlString
                murmurData["selectedTags"] = selectedTagArray
                
                createMurmur()
                
            case .failure(let error):
                print(error)
            }
        }

    }
    
    func createMurmur() {
        
        // 在總 murmurTest 新增資料
        let documentReference = database.collection("murmurTest").document()
        documentReference.setData(murmurData)
        
        // 在目前用戶的 postedMurmur 新增資料
        database.collection("userTest").document(currentUserUID).collection("postedMurmurs").document(documentReference.documentID).setData(murmurData) { error in
            
            self.view.makeToast("成功發布 Murmur", duration: 1, position: .center) { didTap in
                
                self.tabBarController?.selectedIndex = 0
                self.navigationController?.popToRootViewController(animated: true)
                
            }
            
        }
        
    }
    
    
    
}

extension PostTagViewController: UICollectionViewDelegate, UICollectionViewDataSource {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 2
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return selectedTagArray.count
            
        } else {
            return MWtagArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(PostTagCollectionReusableHeaderView.self)", for: indexPath) as? PostTagCollectionReusableHeaderView else { return UICollectionReusableView() }
            headerView.label.text = "你的塗鴉內容與什麼有關呢？"  //"About your murmurs"
//                        headerView.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 50)
            return headerView
            
        } else if kind == UICollectionView.elementKindSectionFooter {
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(PostTagCollectionReusableFooterView.self)", for: indexPath) as? PostTagCollectionReusableFooterView else { return UICollectionReusableView() }
            footerView.label.text = "\(selectedTagArray.count) / 5 (At least one)"
            
            return footerView
            
        } else {
            return UICollectionReusableView()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SelectedTagCollectionViewCell.self)", for: indexPath) as? SelectedTagCollectionViewCell else { return SelectedTagCollectionViewCell()}
            cell.titleLabel.text = selectedTagArray[indexPath.row]
            cell.layoutSubviews()
            
            return cell
            
        } else if indexPath.section == 1 {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TagCollectionViewCell.self)", for: indexPath) as? TagCollectionViewCell else { return TagCollectionViewCell()}
            cell.titleLabel.text = MWtagArray[indexPath.row]
            cell.layoutSubviews()
            
            return cell
            
        } else {
            return UICollectionViewCell()
            
        }
        
    }
    
    // 調整 Header 尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
//            let headerView = PostTagCollectionReusableHeaderView() // 創建一個暫時的 headerView
//            // 設定 headerView 的內容
//            headerView.label.text = "你的塗鴉內容跟什麼有關呢？"  //"About your murmurs"
////            headerView.label.font = .systemFont(ofSize: 28)
////            headerView.translatesAutoresizingMaskIntoConstraints = false
////             根據內容計算動態大小
//            let fittingSize = CGSize(width: collectionView.frame.width, height: UIView.layoutFittingCompressedSize.height)
//            let size = headerView.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
//            return size
            
            // selectedTag 區
            return CGSize(width: 0, height: 80)
            
        } else {
            return .zero
        }
    }
    
    // 調整 Footer 尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            let footerView = PostTagCollectionReusableFooterView() // 創建一個暫時的 headerView
            // 設定 headerView 的內容
            footerView.label.text = "1 / 5 (At least 1)"
//            footerView.label.font = .systemFont(ofSize: 28)
//            footerView.translatesAutoresizingMaskIntoConstraints = false
            // 根據內容計算動態大小
            let fittingSize = CGSize(width: collectionView.frame.width, height: UIView.layoutFittingCompressedSize.height)
            let size = footerView.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            return size
//            return CGSize(width: view.frame.size.width, height: view.frame.size.width / 5)
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let disSelectedtag = selectedTagArray.remove(at: indexPath.row)
            MWtagArray.insert(disSelectedtag, at: 0)
            
        } else if indexPath.section == 1 {
            
            if selectedTagArray.count >= 5 {
                return
            }
            let selectedtag = MWtagArray.remove(at: indexPath.row)
            selectedTagArray.append(selectedtag)
            
        } else {
            print("Error: 未知的 section")
        }
    }
        
}

extension PostTagViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 16, left: 0, bottom: 4, right: 16)
        } else {
            return UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 16)
        }

    }
    
    

}

