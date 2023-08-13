//
//  PostDetailsViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/7/12.
//

protocol PostDetailsPopupViewDelegate: AnyObject {
    func showSettingMenu(view: UIView)
}

import Foundation
import UIKit
import SnapKit

class PostDetailsPopupView: UIView {
    
    weak var delegate: PostDetailsPopupViewDelegate?
    
    var currentRowOfIndexpath: Int?
    var closeClosure: ((UIView, Int) -> Void)?
    var showMenuClosure: ((UIView) -> Void)?
    var tagArray: [String]! {
        didSet {
            tagCollectionView.reloadData()
        }
    }

    let postImageView: UIImageView = {
        let postImageView = UIImageView()
        postImageView.image = UIImage(named: "Placeholder.jpg")
        postImageView.contentMode = .scaleAspectFill
        return postImageView
    }()
    let postCreatedTimeLabel: UILabel = {
        let postCreatedTimeLabel = UILabel()
        postCreatedTimeLabel.textColor = .PrimaryDark?.withAlphaComponent(0.7)
        postCreatedTimeLabel.font = UIFont(name: "PingFangTC-Medium", size: 14)
        return postCreatedTimeLabel
    }()
    let postCreatedSiteLabel: UILabel = {
        let postCreatedSiteLabel = UILabel()
        postCreatedSiteLabel.textColor = .PrimaryDark?.withAlphaComponent(0.7)
        postCreatedSiteLabel.font = UIFont(name: "PingFangTC-Medium", size: 14)
        return postCreatedSiteLabel
    }()
    let postContentLabel: UILabel = {
        let postContentLabel = UILabel()
        postContentLabel.backgroundColor = .PrimaryLighter
        postContentLabel.textColor = .PrimaryDark
        postContentLabel.numberOfLines = 0
        postContentLabel.font = UIFont(name: "PingFangTC-Regular", size: 16)
        return postContentLabel
    }()
    lazy var tagCollectionView: UICollectionView = {
        let layout = TagCollectionViewFlowLayout()
        // section的間距
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        // 每行 cell 間距
        layout.minimumLineSpacing = 8
        // cell 之間間距
        layout.minimumInteritemSpacing = 6
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
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTouchUpInside), for: .touchUpInside)
        closeButton.tintColor = .PrimaryMid
        return closeButton
    }()
    private lazy var setButton: UIButton = {
        let setButton = UIButton()
        setButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        setButton.addTarget(self, action: #selector(setButtonTouchUpInside), for: .touchUpInside)
        setButton.tintColor = .PrimaryMid
        return setButton
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
        self.showMenuClosure!(self)
//        animateScaleOut(desiredView: popupView)
//        animateScaleOut(desiredView: blurView)
    }
    
    @objc func setButtonTouchUpInside() {
        
        self.delegate?.showSettingMenu(view: self)
        
//        let presentVC = ChatRoomPresentViewController()
//        presentVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
////        presentVC.modalPresentationStyle = UIModalPresentationStyle.custom
////        presentVC.modalPresentationStyle = .fullScreen
//        presentVC.modalTransitionStyle = .coverVertical
//
//        self.present(presentVC, animated: true) { [self] in
//
//            self.blackView.backgroundColor = .black
//            blackView.alpha = 0
//            self.navigationController?.view.addSubview(blackView)
////            self.view.addSubview(self.blackView)
////            self.view.bringSubviewToFront(self.blackView)
//            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.05, delay: 0) {
//                self.blackView.alpha = 0.5
//            }
//
//        }
//        presentVC.cancelClosure = { _ in
//            self.blackView.removeFromSuperview()
//        }
        
    }
    
    func layoutView() {
 
        [postImageView, postCreatedTimeLabel, postCreatedSiteLabel, postContentLabel, tagCollectionView, closeButton, setButton].forEach { subview in
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
        postCreatedTimeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        postCreatedSiteLabel.snp.makeConstraints { make in
            make.top.equalTo(postCreatedTimeLabel.snp.bottom).offset(6)
            make.centerX.equalTo(self)
        }
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(postCreatedSiteLabel.snp.bottom).offset(8)
            make.leading.equalTo(self).offset(32)
            make.trailing.equalTo(self).offset(-32)
            make.height.equalTo(94)
        }
        postContentLabel.snp.makeConstraints { make in
            make.top.equalTo(tagCollectionView.snp.bottom).offset(16)
            make.leading.equalTo(self).offset(56)
            make.trailing.lessThanOrEqualTo(self).offset(-56)
            make.bottom.lessThanOrEqualTo(self).offset(-40)
        }
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.leading.equalTo(24)
            make.top.equalTo(24)
        }
        setButton.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.trailing.equalTo(-24)
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
        cell.titleLabel.text = tagArray[indexPath.row]
        
        
        return cell
    }
        
}

extension PostDetailsPopupView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 0)
    }

}
