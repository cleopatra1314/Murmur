//
//  File.swift
//  Murmur
//
//  Created by cleopatra on 2023/7/5.
//

import Foundation
import UIKit

class SelfSizingTableView: UITableView {
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    override var intrinsicContentSize: CGSize {
        let height = min(.infinity, contentSize.height)
        return CGSize(width: contentSize.width, height: height)
    }
    
}
