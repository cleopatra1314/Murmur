//
//  ChatRoomPresent.swift
//  Murmur
//
//  Created by cleopatra on 2023/8/12.
//

import Foundation
import UIKit
import SnapKit

class ChatRoomPresentViewController: UIViewController {
    
    var cancelClosure: ((UIViewController) -> (Void))?
    var otherUserName = String()
    let menuView = UIView()
    lazy var cancelButton: UIButton = {
        var cancelButton = UIButton()
        cancelButton.backgroundColor = .GrayScale0
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.GrayScale90, for: .normal)
        cancelButton.layer.cornerRadius = 14
        cancelButton.addTarget(self, action: #selector(cancelButtonTouchupInside), for: .touchUpInside)
        return cancelButton
    }()
    lazy var blockButton: UIButton = {
        let blockButton = UIButton()
        blockButton.backgroundColor = .GrayScale0
        blockButton.setTitle("Block", for: .normal)
        blockButton.setTitleColor(UIColor.ErrorDefault, for: .normal)
        blockButton.layer.cornerRadius = 14
        blockButton.addTarget(self, action: #selector(blockButtonTouchupInside), for: .touchUpInside)
        return blockButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        self.view?.backgroundColor = .GrayScale80?.withAlphaComponent(0.0)
    }
    
    @objc func cancelButtonTouchupInside() {
        self.dismiss(animated: true)
        self.cancelClosure!(self)
    }
    
    @objc func blockButtonTouchupInside() {
        self.showCustomAlert(title: "Block \(otherUserName) ?", message: "They won't be able to message you and you won't see each other on the map. Are you sure you want to block this user ?", viewController: self, okMessage: "Block", closeMessage: "Cancel") {
            print("給我封鎖他")
        }
    }
    
    func setView() {
      
        [cancelButton, blockButton].forEach { subview in
            self.view.addSubview(subview)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view).offset(-40)
            make.leading.equalTo(self.view).offset(16)
            make.trailing.equalTo(self.view).offset(-16)
            make.height.equalTo(44)
        }
        blockButton.snp.makeConstraints { make in
            make.bottom.equalTo(cancelButton.snp.top).offset(-8)
            make.leading.equalTo(self.view).offset(16)
            make.trailing.equalTo(self.view).offset(-16)
            make.height.equalTo(44)
        }
        
    }
}
