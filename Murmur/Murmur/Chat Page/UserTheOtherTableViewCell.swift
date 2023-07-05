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
        profileImageView.layer.cornerRadius = 10
        profileImageView.clipsToBounds = true
        return profileImageView
    }()
    let dialogTextView: UITextView = {
        let dialogTextView = UITextView()
        dialogTextView.textContainerInset = .init(top: 8, left: 12, bottom: 8, right: 12)
        dialogTextView.backgroundColor = .PrimaryMiddle
        dialogTextView.font = UIFont(name: "PingFangTC-Regular", size: 16)
        dialogTextView.textColor = .GrayScale90
        dialogTextView.layer.cornerRadius = 16
        dialogTextView.isScrollEnabled = false
        
        return dialogTextView
    }()
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        dialogTextView.layer.addMessagesShadow()
        
    }
    
    func layoutCell() {
        
        self.backgroundColor = .PrimaryLight
        
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(dialogTextView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        dialogTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: dialogTextView.topAnchor, constant: 4),
            profileImageView.heightAnchor.constraint(equalToConstant: 30),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor, multiplier: 1),
            dialogTextView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 14),
            dialogTextView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            dialogTextView.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: -40),
            dialogTextView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12)
        ])
    }
    
}
