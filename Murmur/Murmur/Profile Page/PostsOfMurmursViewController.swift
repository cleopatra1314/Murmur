//
//  PostsCollectionView.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/27.
//

import Foundation
import UIKit
import Kingfisher

class PostsOfMurmursViewController: UIViewController {
    
    var showPostsDetailsPopupClosure: (([Murmurs], Int) -> Void)?
    
    var murmurData: [Murmurs]? {
        didSet {
            // TODO: collectionView reloadData
            layoutCollectionView()
        }
    }
    
//    private let postsCollectionView: UICollectionView = {
//        let postsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: post)
//        postsCollectionView.backgroundColor = .green
//        return postsCollectionView
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMurmurData()
        layoutCollectionView()
        
    }
    
    func fetchMurmurData() {
        
        database.collection("userTest").document(currentUserUID).collection("postedMurmurs").order(by: "createTime", descending: true).addSnapshotListener { querySnapshot, error in
            
            guard let querySnapshot else {
                print("fetchMurmurData", error)
                return
            }
            
            let murmurs = querySnapshot.documents.compactMap { querySnapshot in
                do {
                    return try querySnapshot.data(as: Murmurs.self)
                    
                } catch {
                    print("fetchMurmurData", error)
                    return nil
                }
            }
            self.murmurData = murmurs
            
        }
    }
    
    func layoutCollectionView() {
        
        // TODO: postsCollectionView 在 viewDidLoad 之前 init() 的話會報錯 collectionViewLayout 為 nil，因為在外面無法先指定 postsCollectionViewFlowLayout
        let postsCollectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let postsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: postsCollectionViewFlowLayout)
        
        postsCollectionView.backgroundColor = .PrimaryDefault
        
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
            make.top.bottom.equalTo(self.view).offset(16)
       
        }
        
    }
    
}

extension PostsOfMurmursViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        murmurData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: return UICollectionViewCell() 的寫法
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PostsCollectionViewCell.self)", for: indexPath) as? PostsCollectionViewCell else { return UICollectionViewCell() }
        
        if murmurData![indexPath.row].murmurImage == "" {
            cell.postsImageView.image = UIImage(named: "Placeholder.jpg")
        } else {
            cell.postsImageView.kf.setImage(with: URL(string: murmurData![indexPath.row].murmurImage))
        }
        
        cell.postsLabel.text = murmurData![indexPath.row].murmurMessage
        cell.layer.cornerRadius = 32
//        cell.clipsToBounds = true
        cell.layer.addShineShadow()

        return cell
    }
    
}

extension PostsOfMurmursViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.showPostsDetailsPopupClosure!(murmurData!, indexPath.row)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        //        // 定義UIContextMenuConfiguration物件
        //        let config = UIContextMenuConfiguration(identifier: nil,
        //        previewProvider: nil) { (elements) -> UIMenu? in
        //        // 這裡定義想增加的功能，這裡是一個刪除功能
        //        let delete = UIAction(title: "Delete") { (action) in
        //
        //        // 自己定義的function
        ////        self.deleteMeme(at: indexPath)
        //        }
        //        // 把功能加進UIMenu物件
        //        return UIMenu(title: "", image: nil, identifier: nil,
        //        options: [], children: [delete])
        //        }
        //        return config
        //        }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: {
            suggestedActions in
            
            // 欄位1
            let favoriteAction = UIAction(title: "Hide", image: UIImage(systemName: "eye.slash"), state: .off) { action in
                print("Hide the murmur.")
                self.showAlert(title: "新功能開發中，敬請期待！💜", message: "", viewController: self)
            }
            // 欄位2
            let shareAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), state: .off) { action in
                self.showCustomAlert(title: "提醒！", message: "刪除貼文後將無法恢復貼文紀錄，確定要刪除嗎？", viewController: self, okMessage: "確定", closeMessage: "取消") { [self] in
                    
                    // userTest -> postedMurmurs
                    database.collection("userTest").document(currentUserUID).collection("postedMurmurs").document(murmurData![indexPath.row].id!).delete(completion: { error in
                        
                        // 刪除 murmurTest
                        database.collection("murmurTest").document(murmurData![indexPath.row].id!).delete(completion: { error in
                            self.view.makeToast("已刪除 murmur ", duration: 3.0, position: .top)
                        })
                        
                    })
                    
                }
            }
            
            //標題
            return UIMenu(title: "Menu", children: [favoriteAction, shareAction])
        })
        
    }
    
}
