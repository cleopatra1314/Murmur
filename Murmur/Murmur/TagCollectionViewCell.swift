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
        titleOfButtonLabel.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        titleOfButtonLabel.font = UIFont(name: "PingFangTC-Regular", size: 14)
        return titleOfButtonLabel
    }()
//    var twitClosure: ((ChatBotBottomCollectionViewCell) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutCell(){
        contentView.addSubview(tagButton)
        tagButton.addSubview(titleOfButtonLabel)
        
        titleOfButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        tagButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleOfButtonLabel.leadingAnchor.constraint(equalTo: tagButton.leadingAnchor, constant: 16),
            titleOfButtonLabel.trailingAnchor.constraint(equalTo: tagButton.trailingAnchor, constant: -16),
            titleOfButtonLabel.topAnchor.constraint(equalTo: tagButton.topAnchor, constant: 10),
            titleOfButtonLabel.bottomAnchor.constraint(equalTo: tagButton.bottomAnchor, constant: -10),
            tagButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tagButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tagButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            tagButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        tagButton.backgroundColor = .white
        tagButton.layer.cornerRadius = 20
        tagButton.layer.borderWidth = 1
        tagButton.layer.borderColor = UIColor.PrimaryMiddle?.cgColor
//        tagButton.setTitleColor(UIColor.black, for: .normal)
//        tagButton.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 8, right: 8)
        tagButton.addTarget(self, action: #selector(tagButtonTouchUpInside), for: .touchUpInside)
    }
    
    
    @objc func tagButtonTouchUpInside(){
//        self.twitClosure!(self)
        print("點擊 \(self)")
    }
    
    
}

