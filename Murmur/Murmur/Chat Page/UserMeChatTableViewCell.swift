//
//  MeChatTableViewCell.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/22.
//

import Foundation
import UIKit

class UserMeChatTableViewCell: UITableViewCell {
    
   let dialogTextView: UITextView = {
        let dialogTextView = UITextView()
        dialogTextView.textContainerInset = .init(top: 8, left: 12, bottom: 8, right: 12)
        dialogTextView.backgroundColor = UIColor(red: 0/255, green: 104/255, blue: 139/255, alpha: 1)
        dialogTextView.font = UIFont(name: "PingFangTC-Regular", size: 14)
        dialogTextView.textColor = UIColor(red: 176/255, green: 266/255, blue: 255/255, alpha: 1)
        dialogTextView.layer.cornerRadius = 18
        dialogTextView.isScrollEnabled = false

        return dialogTextView
    }()
    
    func layoutCell() {
        self.contentView.addSubview(dialogTextView)
        
        dialogTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dialogTextView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            dialogTextView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            dialogTextView.leadingAnchor.constraint(greaterThanOrEqualTo: self.contentView.leadingAnchor, constant: 16),
            dialogTextView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
        ])
    }
    
}
