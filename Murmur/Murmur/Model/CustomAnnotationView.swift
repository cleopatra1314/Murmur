//
//  CustomAnnotationView.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/17.
//

import Foundation
import MapKit

class CustomAnnotationView: MKAnnotationView {
    
    var label = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.PrimaryLightest?.withAlphaComponent(0.9)
//        frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        layer.cornerRadius = 15
        layer.borderColor = UIColor.PrimaryLight?.cgColor
        layer.borderWidth = 1
        layer.addShineShadow()
        
        // 設置標籤文字
        label.textAlignment = .center
        label.textColor = UIColor.PrimaryMid
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = annotation?.title ?? ""
        
        // 計算標籤的最小尺寸並調整膠囊寬度不要超過 190，超過即以...表示
        let labelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        if (labelSize.width + 24) > 190 {
            frame = CGRect(x: 0, y: 0, width: 190, height: labelSize.height + 16)
        } else {
            frame = CGRect(x: 0, y: 0, width: labelSize.width + 24, height: labelSize.height + 16)
        }
    
        // 設置標籤的位置
        label.frame = bounds.inset(by: UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10))
        addSubview(label)
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        // 設置膠囊形狀外觀
        
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
