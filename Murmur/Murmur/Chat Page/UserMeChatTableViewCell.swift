//
//  MeChatTableViewCell.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/22.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift
import FirebaseFirestore
import SnapKit

class UserMeChatTableViewCell: UITableViewCell {
    
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
        dialogTextView.backgroundColor = .SecondaryDefault
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
        return createdTimeLabel
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
        
        self.contentView.addSubview(stack)
        stack.addArrangedSubview(createdTimeLabel)
        stack.addArrangedSubview(dialogTextView)
        
        stack.snp.makeConstraints { make in
            make.top.equalTo(self.contentView).offset(14)
            make.bottom.equalTo(self.contentView).offset(-12)
            make.trailing.equalTo(self.contentView).offset(-16)
            make.leading.greaterThanOrEqualTo(self.contentView).offset(48)
        }
//        createdTimeLabel.snp.makeConstraints { make in
//            make.trailing.equalTo(dialogTextView.snp.leading).offset(-8)
//            make.leading.equalTo(stack)
//        }
//        createdTimeLabel.setContentHuggingPriority(.required, for: .horizontal)
//        dialogTextView.setContentHuggingPriority(.required, for: .horizontal)
        dialogTextView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        createdTimeLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

    }
    
}
