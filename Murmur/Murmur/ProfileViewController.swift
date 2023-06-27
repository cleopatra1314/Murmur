//
//  ProfileViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/15.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    private let backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "profileBackground.jpg")
        backgroundImageView.contentMode = .scaleAspectFill
        return backgroundImageView
    }()
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 52/255, green: 92/255, blue: 104/255, alpha: 0.8)
        return backgroundView
    }()
    
    let profileCollectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private let profileCollectionView: UICollectionView = {
        let profileCollectionView = UICollectionView()
        profileCollectionView.backgroundColor = .green
        return profileCollectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutBackground()
        layoutCollectionView()

    }
    
    func layoutBackground() {
        [backgroundImageView, backgroundView].forEach { subview in
            self.view.addSubview(subview)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
    
    
    
    func layoutCollectionView(){
        
        profileCollectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10) // section與section之間的距離(如果只有一個section，可以想像成frame)
        profileCollectionViewFlowLayout.itemSize = CGSize(width: (self.view.frame.size.width - 30) / 2, height: 120) // cell的寬、高
        profileCollectionViewFlowLayout.minimumLineSpacing = CGFloat(integerLiteral: 10) // 滑動方向為「垂直」的話即「上下」的間距;滑動方向為「平行」則為「左右」的間距
        profileCollectionViewFlowLayout.minimumInteritemSpacing = CGFloat(integerLiteral: 10) // 滑動方向為「垂直」的話即「左右」的間距;滑動方向為「平行」則為「上下」的間距
        profileCollectionViewFlowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical // 滑動方向預設為垂直。注意若設為垂直，則cell的加入方式為由左至右，滿了才會換行；若是水平則由上往下，滿了才會換列
        
        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
        
        profileCollectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: "\(ProfileCollectionViewCell.self)")
        
        self.view.addSubview(profileCollectionView)
        
        profileCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalTo(self.view.safeAreaLayoutGuide)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
    }
    
    
    
}

extension ProfileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            return 1
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CollectionViewCell.self)", for: indexPath) as! CollectionViewCell
        cell.imageView.image = UIImage(named: "聖鬥士星矢\(indexPath.item + 1)")
        return cell
    }
    
}

extension ProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("row: \(indexPath.row)")
        }
    
}
