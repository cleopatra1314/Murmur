//
//  PostTagCollectionReusableFooterView.swift
//  Murmur
//
//  Created by cleopatra on 2023/7/16.
//

import UIKit

class PostTagCollectionReusableFooterView: UICollectionReusableView {
        
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "3 / 5 (At least 1)"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .PrimaryDark
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .PrimaryLighter
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
