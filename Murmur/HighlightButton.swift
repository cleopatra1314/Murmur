//
//  CusTomedButton.swift
//  Murmur
//
//  Created by cleopatra on 2023/7/23.
//

import Foundation
import UIKit


class HighlightButton: UIButton {
    // 存储highlight状态时的背景颜色
    var highlightedBackgroundColor: UIColor?

    // 按钮highlight状态发生变化时，会自动调用该观察器
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.backgroundColor = .SecondaryShine?.withAlphaComponent(0.6)
            } else {
                self.backgroundColor = .clear
            }
        }
    }

    // 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
    
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
     
    }

    // 设置按钮的一些默认属性
    private func setupButton() {
        // 为按钮添加一些默认样式，例如圆角和边框等
        layer.cornerRadius = 8.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        clipsToBounds = true
        // 设置按钮正常状态下的背景颜色
        backgroundColor = .white
    }
}

