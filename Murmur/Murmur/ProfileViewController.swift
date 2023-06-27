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
        backgroundView.backgroundColor = UIColor(red: 52/255, green: 92/255, blue: 104/255, alpha: 0.7)
        return backgroundView
    }()
    private let upperView: UIView = {
        let upperView = UIView()
        upperView.backgroundColor = .red
        return upperView
    }()
    private let profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.image = UIImage(named: "User1Portrait.jpg")
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.cornerRadius = 10
        return profileImageView
    }()
    private let userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.text = currentUserUID
        userNameLabel.textColor = .white
        return userNameLabel
    }()
    private let murmurLabel: UILabel = {
        let murmurLabel = UILabel()
        murmurLabel.text = "最新塗鴉最新塗鴉最新塗鴉最新塗鴉最新塗鴉最新塗鴉最新塗鴉最新塗鴉最新塗鴉"
        murmurLabel.textColor = .white
        return murmurLabel
    }()
    
//    private let profileCollectionView: UICollectionView = {
//        let profileCollectionView = UICollectionView()
//        profileCollectionView.backgroundColor = .clear
//        return profileCollectionView
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutBackground()
        layoutView()

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
    
    func layoutView() {
        
   
        self.view.addSubview(upperView)
        
        [profileImageView, userNameLabel, murmurLabel].forEach { subview in
            upperView.addSubview(subview)
        }
        
        upperView.snp.makeConstraints { make in
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(self.view.snp.height).multipliedBy(3/5)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalTo(self.view)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.center.equalTo(upperView)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.bottom.equalTo(userNameLabel.snp.top).offset(-24)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
        murmurLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(88)
            make.width.equalTo(176)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
    }
    
    

}
