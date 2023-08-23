//
//  UITabBar_Extension.swift
//  Murmur
//
//  Created by cleopatra on 2023/8/23.
//

import Foundation
import UIKit

fileprivate let lxfFlag: Int = 666

extension UITabBar {
    // MARK:- 显示小红点
    func showBadgOn(index itemIndex: Int, tabbarItemNums: CGFloat = 4.0) {
        // 移除之前的小红点
        self.removeBadgeOn(index: itemIndex)
        
        // 创建小红点
        let bageView = UIView()
        bageView.tag = itemIndex + lxfFlag
        bageView.layer.cornerRadius = 5
        bageView.backgroundColor = UIColor.ErrorMidDark
        let tabFrame = self.frame
        
        // 确定小红点的位置
        let percentX: CGFloat = (CGFloat(itemIndex) + 0.59) / tabbarItemNums
        let xPosition: CGFloat = CGFloat(ceilf(Float(percentX * tabFrame.size.width)))
        let yPosition: CGFloat = CGFloat(ceilf(Float(0.1 * tabFrame.size.height))) // CGFloat(ceilf(Float(0.115 * tabFrame.size.height)))
        bageView.frame = CGRect(x: xPosition, y: yPosition, width: 10, height: 10)
        self.addSubview(bageView)
    }
    
    // MARK:- 隐藏小红点
    func hideBadge(on itemIndex: Int) {
        // 移除小红点
        self.removeBadgeOn(index: itemIndex)
    }
    
    // MARK:- 移除小红点
    fileprivate func removeBadgeOn(index itemIndex: Int) {
        // 按照tag值进行移除
        _ = subviews.map {
            if $0.tag == itemIndex + lxfFlag {
                $0.removeFromSuperview()
            }
        }
    }
}
