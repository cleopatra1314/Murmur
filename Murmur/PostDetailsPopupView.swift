//
//  PostDetailsViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/7/12.
//

import Foundation
import UIKit
import SnapKit

class PostDetailsPopupView: UIView {
    
    var currentRowOfIndexpath: Int?
    var closeClosure: ((UIView, Int) -> Void)?
    var tagArray = ["food", "fun", "weird", "motorcycle"]

    let postImageView: UIImageView = {
        let postImageView = UIImageView()
        postImageView.image = UIImage(named: "Placeholder.jpg")
        postImageView.contentMode = .scaleAspectFill
        return postImageView
    }()
    let postCreatedTimeLabel: UILabel = {
        let postCreatedTimeLabel = UILabel()
        postCreatedTimeLabel.textColor = .PrimaryDark
        postCreatedTimeLabel.font = UIFont(name: "PingFangTC-Medium", size: 14)
        return postCreatedTimeLabel
    }()
    let postCreatedSiteLabel: UILabel = {
        let postCreatedSiteLabel = UILabel()
        postCreatedSiteLabel.textColor = .PrimaryDark
        postCreatedSiteLabel.font = UIFont(name: "PingFangTC-Medium", size: 14)
        return postCreatedSiteLabel
    }()
    let postContentTextView: UITextView = {
        let postContentTextView = UITextView()
        postContentTextView.backgroundColor = .PrimaryLighter
        postContentTextView.textColor = .PrimaryDark
        postContentTextView.font = UIFont(name: "PingFangTC-Regular", size: 16)
        return postContentTextView
    }()
    lazy var tagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        // section的間距
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        // cell間距
        layout.minimumLineSpacing = 6
        // cell 長寬
        //        layout.itemSize = CGSize(width: 100, height: 30)
        // 滑動的方向
        layout.scrollDirection = .vertical
        // 以 auto layout 計算 cell 大小
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        // collectionView frame設定 x,y,寬,高
        let tagCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        // 背景顏色
        tagCollectionView.backgroundColor = .PrimaryLighter
        // 你所註冊的cell
        tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "\(TagCollectionViewCell.self)")
        
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        
        return tagCollectionView
    }()
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "Icons_Close.png"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTouchUpInside), for: .touchUpInside)
        return closeButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .PrimaryLighter
        self.layer.cornerRadius = 40
        
        layoutView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        postImageView.layer.cornerRadius = postImageView.frame.height / 2
        postImageView.clipsToBounds = true
    }
    
    @objc func closeButtonTouchUpInside() {
        
        self.closeClosure!(self, currentRowOfIndexpath ?? 0)
//        animateScaleOut(desiredView: popupView)
//        animateScaleOut(desiredView: blurView)
    }
    
    func layoutView() {
 
        [postImageView, postCreatedTimeLabel, postCreatedSiteLabel, postContentTextView, tagCollectionView, closeButton].forEach { subview in
            self.addSubview(subview)
        }

        postImageView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(56)
            make.leading.equalTo(self).offset(30)
            make.trailing.equalTo(self).offset(-30)
            make.height.equalTo(postImageView.snp.width)
        }
        postCreatedTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(postImageView.snp.bottom).offset(24)
            make.centerX.equalTo(self)
        }
        postCreatedSiteLabel.snp.makeConstraints { make in
            make.top.equalTo(postCreatedTimeLabel.snp.bottom).offset(6)
            make.centerX.equalTo(self)
        }
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(postCreatedSiteLabel.snp.bottom).offset(20)
            make.leading.equalTo(self).offset(40)
            make.trailing.equalTo(self).offset(-40)
            make.height.equalTo(80)
        }
        postContentTextView.snp.makeConstraints { make in
            make.top.equalTo(tagCollectionView.snp.bottom).offset(16)
            make.leading.equalTo(self).offset(60)
            make.trailing.equalTo(self).offset(-60)
            make.bottom.equalTo(self).offset(-40)
        }
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.leading.equalTo(24)
            make.top.equalTo(24)
        }
        
    }
    
}

extension PostDetailsPopupView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tagArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TagCollectionViewCell.self)", for: indexPath) as? TagCollectionViewCell else { return TagCollectionViewCell()}
        cell.titleOfButtonLabel.text = tagArray[indexPath.row]
        
        return cell
    }
        
}
    

extension PostDetailsPopupView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }

}

//extension PostDetailsPopupView: UIContextMenuInteractionDelegate {
//
//    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: {
//            suggestedActions in
//
//            //欄位1
//            let favoriteAction = UIAction(title: "Follow", image: UIImage(systemName: "heart.fill"), state: .off) { (action) in
//                print("Awwwwww")
//            }
//            //欄位2
//            let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up.fill"), state: .off) { (action) in
//                print("Meowwwww")
//            }
//            //標題
//            return UIMenu(title: "Menu", children: [favoriteAction, shareAction])
//        })
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
//
//
//    }
//
//
//}

