//
//  ProfileCollectionViewCell.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/27.
//

import Foundation
import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
//    private let upperView: UIView = {
//        let upperView = UIView()
//        upperView.backgroundColor = .clear
//        return upperView
//    }()
    private let profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.image = UIImage(named: "User1Portrait.jpg")
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.cornerRadius = 12
        profileImageView.clipsToBounds = true
        return profileImageView
    }()
    private let userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.attributedText = NSAttributedString(string: "beta", attributes: [
            NSAttributedString.Key.font: UIFont(name: "PingFangTC-Medium", size: 18.0),
            NSAttributedString.Key.kern: 2.0,
//            NSAttributedString.Key.backgroundColor: UIColor.red
        ])
        userNameLabel.textColor = .white
        return userNameLabel
    }()
    private let murmurLabel: UILabel = {
        let murmurLabel = UILabel()
//        murmurLabel.text = "最新塗鴉最新塗鴉最新塗鴉最新塗鴉最新塗鴉最新塗鴉最"
        // TODO: 修改 Lable Extension
        murmurLabel.addInterlineSpacing(spacingValue: 4)
        murmurLabel.attributedText = NSAttributedString(string: "鳥語花香鳥生活", attributes: [
            NSAttributedString.Key.font: UIFont(name: "PingFangTC-Regular", size: 14.0),
            NSAttributedString.Key.kern: 3.0,
//            NSAttributedString.Key.backgroundColor: UIColor.red
        ])
        murmurLabel.textAlignment = .center
        murmurLabel.numberOfLines = 0
        murmurLabel.textColor = .white
        return murmurLabel
    }()
    private let settingImageView: UIImageView = {
        let settingImageView = UIImageView()
        settingImageView.image = UIImage(systemName: "gearshape")
        settingImageView.tintColor = .white
        return settingImageView
    }()
    
    func layoutView() {
        
        [profileImageView, userNameLabel, murmurLabel, settingImageView].forEach { subview in
            self.contentView.addSubview(subview)
        }

        userNameLabel.snp.makeConstraints { make in
            make.center.equalTo(self.contentView)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.bottom.equalTo(userNameLabel.snp.top).offset(-24)
            make.centerX.equalTo(self.contentView.snp.centerX)
        }
        
        murmurLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(80)
            make.width.equalTo(200)
            make.centerX.equalTo(self.contentView.snp.centerX)
        }
        
        settingImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.top.equalTo(self.contentView).offset(32)
            make.trailing.equalTo(self.contentView).offset(-16)
        }
 
    }
    
}
