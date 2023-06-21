//
//  CustomAnnotationView.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/17.
//

import Foundation
import MapKit

class CustomAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        // 設置膠囊形狀外觀
        backgroundColor = UIColor.white
        frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        layer.cornerRadius = 15
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        
        // 設置標籤文字
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 12)
        print("另一邊的頭標", annotation?.title)
        label.text = annotation?.title ?? ""
        
        // 計算標籤的最小尺寸並調整膠囊寬度
        let labelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        frame = CGRect(x: 0, y: 0, width: labelSize.width + 24, height: labelSize.height + 16)
        
        // 設置標籤的位置
        label.frame = bounds.inset(by: UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10))
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
