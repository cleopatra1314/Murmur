//
//  SearchBarTableViewCell.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/23.
//

import Foundation
import UIKit
import SnapKit

class SearchBarTableViewCell: UITableViewCell {
    
    let searchBarTextField: UITextField = {
        let searchBarTextField = UITextField()
        searchBarTextField.placeholder = "搜尋名字 / 訊息"
        searchBarTextField.layer.cornerRadius = 10
        searchBarTextField.layer.borderColor = UIColor.darkGray.cgColor
        searchBarTextField.layer.borderWidth = 1
        return searchBarTextField
    }()
    
    func layoutCell(){
        searchBarTextField.snp.makeConstraints { make in
            make.top.equalTo(self.contentView).offset(8)
            make.bottom.equalTo(self.contentView).offset(-8)
            make.leading.equalTo(self.contentView).offset(16)
            make.trailing.equalTo(self.contentView).offset(-16)
        }
    }
    
}
