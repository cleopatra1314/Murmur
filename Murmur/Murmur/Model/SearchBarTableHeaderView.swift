//
//  SearchBarTableViewCell.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/23.
//

import Foundation
import UIKit
import SnapKit

class SearchBarTableHeaderView: UITableViewHeaderFooterView {

    let searchBarTextField: MessageTypeTextField = {
        let searchBarTextField = MessageTypeTextField()
        searchBarTextField.placeholder = "搜尋名字 / 訊息"
        searchBarTextField.layer.cornerRadius = 10
        searchBarTextField.layer.borderColor = UIColor.GrayScale60?.cgColor
        searchBarTextField.layer.borderWidth = 1
        return searchBarTextField
    }()
    
    func layoutView() {
        
        self.backgroundColor = .PrimaryLight
        
        self.addSubview(searchBarTextField)
        
        searchBarTextField.snp.makeConstraints { make in
            make.top.equalTo(self).offset(8)
            make.bottom.equalTo(self).offset(-8)
            make.leading.equalTo(self).offset(16)
            make.trailing.equalTo(self).offset(-16)
        }
    }
    
}
