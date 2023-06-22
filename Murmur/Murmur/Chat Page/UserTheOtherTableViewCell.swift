//
//  UserTheOtherTableViewCell.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/22.
//

import Foundation
import UIKit


class UserTheOtherTableViewCell: UITableViewCell {
    
    let profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.image = UIImage(named: "Icon_chatbot.png")
        return profileImageView
    }()
    let dialogTextView: UITextView = {
        let dialogTextView = UITextView()
        dialogTextView.textContainerInset = .init(top: 10, left: 12, bottom: 10, right: 12)
        dialogTextView.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        dialogTextView.font = UIFont(name: "PingFangTC-Regular", size: 16)
        dialogTextView.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        dialogTextView.layer.cornerRadius = 20
        dialogTextView.isScrollEnabled = false
        
        return dialogTextView
    }()
    
    func layoutCell() {
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(dialogTextView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        dialogTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 6),
            profileImageView.heightAnchor.constraint(equalToConstant: 30),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor, multiplier: 1),
            dialogTextView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            dialogTextView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            dialogTextView.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: -16),
            dialogTextView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -6)
        ])
    }
    
}
