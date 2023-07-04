//
//  ProfileCollectionViewCell.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/27.
//

import Foundation
import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    var settingClosure: ((ProfileTableViewCell) -> Void)?
    
    let profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.image = UIImage(named: "User1Portrait.jpg")
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.borderColor = UIColor(red: 226/255, green: 255/255, blue: 246/255, alpha: 1).cgColor
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.cornerRadius = 16
        profileImageView.clipsToBounds = true
        return profileImageView
    }()
    let userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.attributedText = NSAttributedString(string: "beta", attributes: [
            NSAttributedString.Key.font: UIFont(name: "PingFangTC-Medium", size: 18.0),
            NSAttributedString.Key.kern: 2.0,
            NSAttributedString.Key.foregroundColor: UIColor.GrayScale20
//            NSAttributedString.Key.backgroundColor: UIColor.red
        ])
//        userNameLabel.textColor = .white
        return userNameLabel
    }()
    let murmurLabel: UILabel = {
        let murmurLabel = UILabel()
//        murmurLabel.text = "最新塗鴉最新塗鴉最新塗鴉最新塗鴉最新塗鴉最新塗鴉最"
        // TODO: 修改 Lable Extension
        murmurLabel.addInterlineSpacing(spacingValue: 5)
        murmurLabel.attributedText = NSAttributedString(string: "逮吧直直撞 直直撞 直直撞直直撞", attributes: [
            NSAttributedString.Key.font: UIFont(name: "PingFangTC-Regular", size: 13.0),
            NSAttributedString.Key.kern: 3.0,
            NSAttributedString.Key.foregroundColor: UIColor.GrayScale20
//            NSAttributedString.Key.backgroundColor: UIColor.red
        ])
        murmurLabel.textAlignment = .center
        murmurLabel.numberOfLines = 0
//        murmurLabel.textColor = .white
        return murmurLabel
    }()
    private lazy var settingButton: UIButton = {
        let settingButton = UIButton()
        settingButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        settingButton.tintColor = .SecondaryLight
        settingButton.addTarget(self, action: #selector(settingButtonTouchUpInside), for: .touchUpInside)
        return settingButton
    }()
    
    func layoutView() {
        
        [profileImageView, userNameLabel, murmurLabel, settingButton].forEach { subview in
            self.contentView.addSubview(subview)
        }

        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.bottom.equalTo(userNameLabel.snp.top).offset(-24)
            make.centerX.equalTo(self.contentView.snp.centerX)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.center.equalTo(self.contentView)
        }
        
        murmurLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(80)
            make.width.equalTo(200)
            make.centerX.equalTo(self.contentView.snp.centerX)
        }
        
        settingButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.top.equalTo(self.contentView).offset(4)
            make.trailing.equalTo(self.contentView).offset(-16)
        }
 
    }
    
    @objc func settingButtonTouchUpInside(){
        
        self.settingClosure!(self)
        
    }
    
}