//
//  PostsCollectionView.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/27.
//

import Foundation
import UIKit

class PostsViewController: UIViewController {
    
//    private let postsCollectionView: UICollectionView = {
//        let postsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: post)
//        postsCollectionView.backgroundColor = .green
//        return postsCollectionView
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutCollectionView()
        
    }
    
    func layoutCollectionView() {
        
        // TODO: postsCollectionView 在 viewDidLoad 之前 init() 的話會報錯 collectionViewLayout 為 nil，因為在外面無法先指定 postsCollectionViewFlowLayout
        let postsCollectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let postsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: postsCollectionViewFlowLayout)
        
        postsCollectionView.backgroundColor = UIColor(red: 28/255, green: 38/255, blue: 45/255, alpha: 1)
        
//        postsCollectionView.frame = self.view.bounds
        postsCollectionView.collectionViewLayout =  postsCollectionViewFlowLayout
        
        postsCollectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10) // section與section之間的距離(如果只有一個section，可以想像成frame)
        postsCollectionViewFlowLayout.itemSize = CGSize(width: (self.view.frame.size.width - 80) / 2, height: 200) // cell的寬、高
        postsCollectionViewFlowLayout.minimumLineSpacing = CGFloat(integerLiteral: 32) // 滑動方向為「垂直」的話即「上下」的間距;滑動方向為「平行」則為「左右」的間距
        postsCollectionViewFlowLayout.minimumInteritemSpacing = CGFloat(integerLiteral: 0) // 滑動方向為「垂直」的話即「左右」的間距;滑動方向為「平行」則為「上下」的間距
        postsCollectionViewFlowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical // 滑動方向預設為垂直。注意若設為垂直，則cell的加入方式為由左至右，滿了才會換行；若是水平則由上往下，滿了才會換列
        
        postsCollectionView.dataSource = self
        postsCollectionView.delegate = self
        
        postsCollectionView.register(PostsCollectionViewCell.self, forCellWithReuseIdentifier: "\(PostsCollectionViewCell.self)")
        
        self.view.addSubview(postsCollectionView)
//        postsCollectionView.frame = self.view.bounds
        postsCollectionView.snp.makeConstraints { make in
            make.leading.equalTo(self.view).offset(16)
            make.trailing.equalTo(self.view).offset(-16)
            make.top.equalTo(self.view).offset(16)
            make.top.bottom.equalTo(self.view)
        }
        
    }
    
}

extension PostsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: return UICollectionViewCell() 的寫法
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PostsCollectionViewCell.self)", for: indexPath) as? PostsCollectionViewCell else { return UICollectionViewCell() }
        cell.postsImageView.image = UIImage(named: "test2.jpg")
//        cell.postsLabel.text = "這邊有很大的陽台"
        cell.backgroundColor = UIColor(red: 32/255, green: 44/255, blue: 52/255, alpha: 1)
        cell.layer.cornerRadius = 14
//        cell.clipsToBounds = true
        cell.layer.addShadow()
//        cell.layer.borderColor = UIColor(red: 132/255, green: 218/255, blue: 231/255, alpha: 1).cgColor
//        cell.layer.borderWidth = 0.8
        
        cell.layoutView()
        return cell
    }
    
}

extension PostsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("row: \(indexPath.row)")
    }
    
}
