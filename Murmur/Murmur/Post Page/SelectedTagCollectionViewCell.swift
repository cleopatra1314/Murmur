//
//  SelectedTagCollectionViewCell.swift
//  Murmur
//
//  Created by cleopatra on 2023/7/16.
//

import Foundation
import UIKit


class SelectedTagCollectionViewCell: UICollectionViewCell {

    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .GrayScale20
        titleLabel.font = UIFont(name: "PingFangTC-Regular", size: 13)
        return titleLabel
    }()
    let crossImageView: UIImageView = {
        let crossImageView = UIImageView()
        crossImageView.image = UIImage(systemName: "xmark")
        crossImageView.contentMode = .scaleAspectFit
        crossImageView.tintColor = .GrayScale20
        return crossImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutCell()
        layoutIfNeeded()
//        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutCell() {
        
        self.backgroundColor = .ErrorMidDark
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.GrayScale20?.cgColor
        self.layer.addShineShadow()
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(crossImageView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        crossImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 14),
//            titleOfButtonLabel.trailingAnchor.constraint(equalTo: tagButton.trailingAnchor, constant: -14),
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 9),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -9),
            crossImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            crossImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -14),
//            crossImageView.topAnchor.constraint(equalTo: titleOfButtonLabel.topAnchor, constant: 0),
//            crossImageView.bottomAnchor.constraint(equalTo: titleOfButtonLabel.bottomAnchor, constant: -0),
            crossImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            crossImageView.widthAnchor.constraint(equalToConstant: 16),
            crossImageView.heightAnchor.constraint(equalToConstant: 16),
        ])
        
    }
    
//    override func layoutIfNeeded() {
//        super.layoutIfNeeded()

        // TODO: 解決 UIView-Encapsulated-Layout
//        tagButton.layer.cornerRadius =  18
//        self.layer.cornerRadius = self.frame.height / 2
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = self.frame.height / 2
    }

}
