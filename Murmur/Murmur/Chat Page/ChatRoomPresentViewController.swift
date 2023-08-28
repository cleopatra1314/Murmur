//
//  ChatRoomPresent.swift
//  Murmur
//
//  Created by cleopatra on 2023/8/12.
//

import Foundation
import UIKit
import SnapKit
import Toast_Swift

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
        blockButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] // 為沒有圓角的部分
        blockButton.addTarget(self, action: #selector(blockButtonTouchupInside), for: .touchUpInside)
        return blockButton
    }()
    lazy var reportButton: UIButton = {
        let reportButton = UIButton()
        reportButton.backgroundColor = .GrayScale0
        reportButton.setTitle("Report", for: .normal)
        reportButton.setTitleColor(UIColor.ErrorDefault, for: .normal)
        reportButton.layer.cornerRadius = 14
        reportButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        reportButton.addTarget(self, action: #selector(reportButtonTouchupInside), for: .touchUpInside)
        return reportButton
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
        self.showCustomAlert(title: "Block \(otherUserName) ?", message: "They won't be able to message you and you won't see each other on the map. Are you sure you want to block this user ?", viewController: self, okMessage: "Block", closeMessage: "Cancel") { [self] in
            
            self.view.makeToast("\(self.otherUserName) is blocked", duration: 2.5, position: .center, style: ToastStyle()) { _ in
                self.cancelButtonTouchupInside()
            }
            
        }
    }
    
    @objc func reportButtonTouchupInside() {
        
       let reportAlertController = UIAlertController(title: "", message: "Why are you reporting this user?", preferredStyle: .actionSheet)
            let reportActions = ["Harassment or bullying", "Posting inappropriate things", "Nudity or sexual activity", "Pretending to be someone"]
            for actionContent in reportActions {
                let reportAction = UIAlertAction(title: actionContent, style: .default) { _ in
                    self.showAlert(title: "Reported", message: "We have received your report message and will deal with it within 24 hrs.", viewController: self)
                }
                reportAlertController.addAction(reportAction)
            }
            let cancelReportAction = UIAlertAction(title: "Cancel", style: .cancel)
            reportAlertController.addAction(cancelReportAction)
            self.present(reportAlertController, animated: true)
        
    }
    
    func setView() {
      
        [cancelButton, blockButton, reportButton].forEach { subview in
            self.view.addSubview(subview)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view).offset(-40)
            make.leading.equalTo(self.view).offset(16)
            make.trailing.equalTo(self.view).offset(-16)
            make.height.equalTo(44)
        }
        blockButton.snp.makeConstraints { make in
            make.bottom.equalTo(cancelButton.snp.top).offset(-12)
            make.leading.equalTo(self.view).offset(16)
            make.trailing.equalTo(self.view).offset(-16)
            make.height.equalTo(44)
        }
        reportButton.snp.makeConstraints { make in
            make.bottom.equalTo(blockButton.snp.top).offset(-2)
            make.leading.equalTo(self.view).offset(16)
            make.trailing.equalTo(self.view).offset(-16)
            make.height.equalTo(44)
        }
        
    }
}
