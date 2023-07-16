//
//  TagCollectionViewCell.swift
//  Murmur
//
//  Created by cleopatra on 2023/7/12.
//

import Foundation
import UIKit


class TagCollectionViewCell: UICollectionViewCell{
    
//    let tagButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    let tagButton = UIButton()
    let titleOfButtonLabel: UILabel = {
        let titleOfButtonLabel = UILabel()
        titleOfButtonLabel.textColor = .PrimaryDark
        titleOfButtonLabel.font = UIFont(name: "PingFangTC-Regular", size: 12)
        return titleOfButtonLabel
    }()
//    var twitClosure: ((ChatBotBottomCollectionViewCell) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutCell()
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutCell() {
        contentView.addSubview(tagButton)
        tagButton.addSubview(titleOfButtonLabel)
        
        titleOfButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        tagButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleOfButtonLabel.leadingAnchor.constraint(equalTo: tagButton.leadingAnchor, constant: 14),
            titleOfButtonLabel.trailingAnchor.constraint(equalTo: tagButton.trailingAnchor, constant: -14),
            titleOfButtonLabel.topAnchor.constraint(equalTo: tagButton.topAnchor, constant: 6),
            titleOfButtonLabel.bottomAnchor.constraint(equalTo: tagButton.bottomAnchor, constant: -6),
            tagButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tagButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tagButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            tagButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        tagButton.backgroundColor = .white
        tagButton.layer.borderWidth = 1
        tagButton.layer.borderColor = UIColor.PrimaryMiddle?.cgColor
//        tagButton.setTitleColor(UIColor.black, for: .normal)
//        tagButton.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 8, right: 8)
        tagButton.layer.addWhiteShadow()
        tagButton.addTarget(self, action: #selector(tagButtonTouchUpInside), for: .touchUpInside)
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()

        tagButton.layer.cornerRadius = tagButton.frame.height / 2
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        tagButton.layer.cornerRadius = tagButton.frame.height / 2
//    }
    
    @objc func tagButtonTouchUpInside() {
//        self.twitClosure!(self)
        print("點擊 \(self)")
    }
    
    
}

