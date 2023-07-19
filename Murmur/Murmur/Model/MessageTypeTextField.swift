//
//  MessageTypeTextField.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/22.
//

import UIKit

class MessageTypeTextField: UITextField {

    let padding = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        self.clearButtonMode = .whileEditing
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        self.clearButtonMode = .whileEditing
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        self.clearButtonMode = .whileEditing
        return bounds.inset(by: padding)
    }
}
