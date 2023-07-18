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
        otherUserImageView.layer.cornerRadius = 10
        otherUserImageView.contentMode = .scaleAspectFill
        otherUserImageView.clipsToBounds = true
        return otherUserImageView
    }()
    let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "PingFangTC-Medium", size: 18.0) ?? UIFont.systemFont(ofSize: 18.0),
        .foregroundColor: UIColor.red,
        .backgroundColor: UIColor.green,
        .underlineStyle: NSUnderlineStyle.single.rawValue,
        .kern: 1.5,
        .paragraphStyle: NSMutableParagraphStyle()
    ]
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    let otherUserNameLabel: UILabel = {
        let otherUserNameLabel = UILabel()
        otherUserNameLabel.textColor = .PrimaryMid
        otherUserNameLabel.font = UIFont(name: "PingFangTC-Medium", size: 18)
        return otherUserNameLabel
    }()
    let otherUserFirstMessageLabel: UILabel = {
        let otherUserFirstMessageLabel = UILabel()
        otherUserFirstMessageLabel.textColor = .PrimaryDark?.withAlphaComponent(0.6)
        otherUserFirstMessageLabel.font = UIFont(name: "PingFangTC-Regular", size: 14)
        return otherUserFirstMessageLabel
    }()
    let messageSendStateImageView: UIImageView = {
        let messageSendStateImageView = UIImageView()
        messageSendStateImageView.image = UIImage(named: "Icons_arrow-down-left.png")
        return messageSendStateImageView
    }()
    let progressCircleView: ProgressCircleView = {
        let progressCircleView = ProgressCircleView()
        return progressCircleView
    }()
    
    func layoutCell() {
        
        progressCircleView.setProgress(frameWidth: 32)
        
        self.backgroundColor = .PrimaryLight
        
        [otherUserNameLabel, otherUserFirstMessageLabel].forEach { subview in
            stack.addArrangedSubview(subview)
        }
        [otherUserImageView, stack, progressCircleView, messageSendStateImageView].forEach { subview in
            self.contentView.addSubview(subview)
        }
        
        otherUserImageView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView).offset(12)
            make.width.equalTo(48)
            make.height.equalTo(otherUserImageView.snp.width)
            make.leading.equalTo(self.contentView).offset(16)
            make.bottom.equalTo(self.contentView).offset(-12)
        }
        
        stack.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView)
            make.leading.equalTo(otherUserImageView.snp.trailing).offset(16)
            make.trailing.greaterThanOrEqualTo(progressCircleView.snp.leading).offset(-40)
        }
        
        progressCircleView.snp.makeConstraints { make in
            make.height.width.equalTo(32)
            make.centerY.equalTo(self.contentView)
            make.trailing.equalTo(messageSendStateImageView.snp.leading).offset(-12)
        }
        messageSendStateImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView)
            make.width.height.equalTo(24)
            make.trailing.equalTo(self.contentView).offset(-16)
        }
        
    }
    
}
