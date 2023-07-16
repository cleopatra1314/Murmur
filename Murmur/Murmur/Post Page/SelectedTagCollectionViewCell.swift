//
//  SelectedTagCollectionViewCell.swift
//  Murmur
//
//  Created by cleopatra on 2023/7/16.
//

import Foundation
import UIKit


class SelectedTagCollectionViewCell: UICollectionViewCell{
    
//    let tagButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    lazy var tagButton: UIButton = {
        let tagButton = UIButton()
        tagButton.backgroundColor = .ErrorMidDark
        tagButton.layer.borderWidth = 0
        tagButton.layer.borderColor = UIColor.GrayScale20?.cgColor
//        tagButton.setTitleColor(UIColor.black, for: .normal)
//        tagButton.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 8, right: 8)
        tagButton.layer.addWhiteShadow()
        tagButton.addTarget(self, action: #selector(tagButtonTouchUpInside), for: .touchUpInside)
        return tagButton
    }()
    let titleOfButtonLabel: UILabel = {
        let titleOfButtonLabel = UILabel()
        titleOfButtonLabel.textColor = .GrayScale0
        titleOfButtonLabel.font = UIFont(name: "PingFangTC-Medium", size: 12)
        return titleOfButtonLabel
    }()
    let symbolOfButtonImageView: UIImageView = {
        let symbolOfButtonImageView = UIImageView()
        symbolOfButtonImageView.image = UIImage(systemName: "xmark")
        symbolOfButtonImageView.contentMode = .scaleAspectFit
        symbolOfButtonImageView.tintColor = .GrayScale20
        return symbolOfButtonImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutCell()
        layoutIfNeeded()
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutCell() {
        contentView.addSubview(tagButton)
        tagButton.addSubview(titleOfButtonLabel)
        tagButton.addSubview(symbolOfButtonImageView)
        
        titleOfButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        tagButton.translatesAutoresizingMaskIntoConstraints = false
        symbolOfButtonImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleOfButtonLabel.leadingAnchor.constraint(equalTo: tagButton.leadingAnchor, constant: 14),
//            titleOfButtonLabel.trailingAnchor.constraint(equalTo: tagButton.trailingAnchor, constant: -14),
            titleOfButtonLabel.topAnchor.constraint(equalTo: tagButton.topAnchor, constant: 6),
            titleOfButtonLabel.bottomAnchor.constraint(equalTo: tagButton.bottomAnchor, constant: -6),
            symbolOfButtonImageView.leadingAnchor.constraint(equalTo: titleOfButtonLabel.trailingAnchor, constant: 8),
            symbolOfButtonImageView.trailingAnchor.constraint(equalTo: tagButton.trailingAnchor, constant: -14),
            symbolOfButtonImageView.topAnchor.constraint(equalTo: titleOfButtonLabel.topAnchor, constant: 4),
            symbolOfButtonImageView.bottomAnchor.constraint(equalTo: titleOfButtonLabel.bottomAnchor, constant: -4),
            symbolOfButtonImageView.widthAnchor.constraint(equalTo: symbolOfButtonImageView.heightAnchor),
            tagButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tagButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tagButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            tagButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()

        tagButton.layer.cornerRadius = tagButton.frame.height / 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        tagButton.layer.cornerRadius = tagButton.frame.height / 2
    }
    
    @objc func tagButtonTouchUpInside(){
//        self.twitClosure!(self)
        print("點擊 \(self)")
    }
    
    
}


