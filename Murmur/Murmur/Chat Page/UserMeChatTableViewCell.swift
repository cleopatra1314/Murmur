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
        dialogTextView.backgroundColor = .SecondaryDefault
        dialogTextView.font = UIFont(name: "PingFangTC-Regular", size: 14)
        dialogTextView.textColor = .GrayScale80
        dialogTextView.layer.cornerRadius = 16
        dialogTextView.isScrollEnabled = false
        
        return dialogTextView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layoutCell()
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        dialogTextView.layer.addMessagesShadow()
        
    }
    
    func layoutCell() {
        
        self.backgroundColor = .PrimaryLight
        
        self.contentView.addSubview(dialogTextView)
        
        dialogTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dialogTextView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 14),
            dialogTextView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            dialogTextView.leadingAnchor.constraint(greaterThanOrEqualTo: self.contentView.leadingAnchor, constant: 64),
            dialogTextView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
//            dialogTextView.heightAnchor.constraint(equalToConstant: 40),
//            dialogTextView.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
}
