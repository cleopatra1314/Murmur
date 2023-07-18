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
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        return profileImageView
    }()
    
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .bottom
        return stack
    }()
    let dialogTextView: UITextView = {
        let dialogTextView = UITextView()
        dialogTextView.textContainerInset = .init(top: 8, left: 12, bottom: 8, right: 12)
        dialogTextView.backgroundColor = .PrimaryMiddle
        dialogTextView.font = UIFont(name: "PingFangTC-Regular", size: 14)
        dialogTextView.textColor = .GrayScale90
        dialogTextView.layer.cornerRadius = 16
        dialogTextView.isScrollEnabled = false
        dialogTextView.isEditable = false
        
        return dialogTextView
    }()
    let createdTimeLabel: UILabel = {
        let createdTimeLabel = UILabel()
        createdTimeLabel.textColor = .GrayScale20
        createdTimeLabel.font = UIFont(name: "PingFangTC-Regular", size: 10)
//        createdTimeLabel.text = "\(Timestamp(date: Date()))"
        createdTimeLabel.text = "08:20"
        return createdTimeLabel
    }()
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        dialogTextView.layer.addMessagesShadow()
        
    }
    
    func layoutCell() {
        
        self.backgroundColor = .PrimaryLight
        
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(stack)
        stack.addArrangedSubview(dialogTextView)
        stack.addArrangedSubview(createdTimeLabel)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: stack.topAnchor, constant: 4),
            profileImageView.heightAnchor.constraint(equalToConstant: 30),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor, multiplier: 1),
            stack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 14),
            stack.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: -40),
            stack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12)
        ])
    }
    
}
