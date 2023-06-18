//
//  PostTagViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/18.
//

import Foundation
import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNav()
    }
    
    private func setNav() {
//        let navigationController = UINavigationController(rootViewController: self)
//        navigationController.modalPresentationStyle = .fullScreen
//        navigationController.navigationBar.barStyle = .default
//        navigationController.navigationBar.backgroundColor = .blue
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.title = "塗鴉標籤"
        
        let closeButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonItemTouchUpInside))
        closeButtonItem.tintColor = .black
        navigationItem.leftBarButtonItem = closeButtonItem
        
        let postButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(postButtonItemTouchUpInside))
        postButtonItem.tintColor = .purple
        navigationItem.rightBarButtonItem = postButtonItem
    }
    
    @objc func closeButtonItemTouchUpInside() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func postButtonItemTouchUpInside() {
//        錯誤寫法
//        self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
//        self.navigationController?.popToViewController((self.tabBarController?.viewControllers![0])!, animated: true)
//        present((self.tabBarController?.viewControllers![0])!, animated: true)
        
        self.tabBarController?.selectedIndex = 0
        let VC = self.tabBarController?.viewControllers![0] as? HomePageViewController
        VC?.switchModeButton.setImage(UIImage(named: "Icons_People"), for: .normal)
        VC?.nearbyUsersContainerView.isHidden = true
        VC?.locationMessageContainerView.isHidden = false
        VC?.switchMode = true
    }
    
}
