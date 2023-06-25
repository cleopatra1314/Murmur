//
//  ChatRoomTableViewCell.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/23.
//

import Foundation
import UIKit
import SnapKit

class ChatRoomTableViewCell: UITableViewCell {
    
    let otherUserImageView: UIImageView = {
        let otherUserImageView = UIImageView()
        return otherUserImageView
    }()
    let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "Helvetica-Bold", size: 18.0) ?? UIFont.systemFont(ofSize: 18.0),
        .foregroundColor: UIColor.red,
        .backgroundColor: UIColor.green,
        .underlineStyle: NSUnderlineStyle.single.rawValue,
        .kern: 1.5,
        .paragraphStyle: NSMutableParagraphStyle()
    ]
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        return stack
    }()
    let otherUserNameLabel: UILabel = {
        let otherUserNameLabel = UILabel()
//        otherUserNameLabel.attributedText
        return otherUserNameLabel
    }()
    let otherUserFirstMessageLabel: UILabel = {
        let otherUserFirstMessageLabel = UILabel()
        otherUserFirstMessageLabel.textColor = .lightGray
        return otherUserFirstMessageLabel
    }()
    let messageSendStateImageView: UIImageView = {
        let messageSendStateImageView = UIImageView()
        messageSendStateImageView.image = UIImage(named: "Icons_arrow-down-left.png")
        return messageSendStateImageView
    }()
    
    func layoutCell() {
        [otherUserNameLabel, otherUserFirstMessageLabel].forEach { subview in
            stack.addArrangedSubview(subview)
        }
        [otherUserImageView, stack, messageSendStateImageView].forEach { subview in
            self.contentView.addSubview(subview)
        }
        
        otherUserImageView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView).offset(6)
            make.width.equalTo(48)
            make.height.equalTo(otherUserImageView.snp.width)
            make.leading.equalTo(self.contentView).offset(16)
            make.bottom.equalTo(self.contentView).offset(-6)
        }
        
        stack.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView)
            make.leading.equalTo(otherUserImageView.snp.trailing).offset(8)
        }
        
        messageSendStateImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(24)
            make.height.equalTo(messageSendStateImageView.snp.width)
            make.trailing.equalTo(self.contentView).offset(-16)
        }
        
    }
    
}
