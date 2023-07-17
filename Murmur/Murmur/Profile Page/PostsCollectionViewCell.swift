//
//  PostsCollectionViewCell.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/28.
//

import Foundation
import UIKit
import SnapKit

class PostsCollectionViewCell: UICollectionViewCell {
    
    let postsImageView: UIImageView = {
        let postsImageView = UIImageView()
        postsImageView.contentMode = .scaleAspectFill
        postsImageView.layer.cornerRadius = 24
        postsImageView.clipsToBounds = true
        return postsImageView
    }()
    let postsLabel: UILabel = {
        let postsLabel = UILabel()
        postsLabel.addInterlineSpacing(spacingValue: 20.0)
        postsLabel.attributedText = NSAttributedString(string: "中文測試postsMurmurmurmurmurmur中文測試中文測試中文測試中文測試", attributes: [
            NSAttributedString.Key.font: UIFont(name: "PingFangTC-Regular", size: 12.0),
            NSAttributedString.Key.kern: 2.0,
            NSAttributedString.Key.foregroundColor: UIColor.GrayScale90
//            NSAttributedString.Key.backgroundColor: UIColor.red
        ])
        postsLabel.numberOfLines = 0
        return postsLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutView() {
       
      self.backgroundColor = .SecondaryLighter
        
        self.contentView.addSubview(postsImageView)
        self.contentView.addSubview(postsLabel)
        
        postsImageView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView).offset(16)
            make.leading.equalTo(self.contentView).offset(16)
            make.trailing.equalTo(self.contentView).offset(-16)
            make.height.equalTo(postsImageView.snp.width).multipliedBy(0.8)
        }
        postsLabel.snp.makeConstraints { make in
            make.top.equalTo(postsImageView.snp.bottom).offset(8)
            make.leading.equalTo(postsImageView)
            make.trailing.equalTo(postsImageView)
            make.bottom.lessThanOrEqualTo(self.contentView).offset(-12)
        }
        
    }
    
}
