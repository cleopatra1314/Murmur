//
//  TagCollectionViewCell.swift
//  Murmur
//
//  Created by cleopatra on 2023/7/12.
//

import Foundation
import UIKit


class TagCollectionViewCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .PrimaryDark
        titleLabel.font = UIFont(name: "PingFangTC-Regular", size: 12)
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutCell()
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutCell() {
        self.backgroundColor = .white
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.PrimaryMiddle?.cgColor
//        tagButton.setTitleColor(UIColor.black, for: .normal)
//        tagButton.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 8, right: 8)
        self.layer.addWhiteShadow()
        
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 9),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -9)
        ])
        
    }
    
//    override func layoutIfNeeded() {
//        super.layoutIfNeeded()
//
//        self.layer.cornerRadius = self.frame.height / 2
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = self.frame.height / 2
    }

    
}

