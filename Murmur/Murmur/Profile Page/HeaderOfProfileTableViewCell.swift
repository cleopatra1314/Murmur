//
//  HeaderOfCollectionView.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/26.
//

import Foundation
import UIKit

class HeaderOfProfileTableViewCell: UITableViewCell {
    
    var selectedButton = UIButton()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    private let postsLabel: UILabel = {
        let postsLabel = UILabel()
        postsLabel.text = "Posts"
        postsLabel.textColor = UIColor(red: 226/255, green: 255/255, blue: 246/255, alpha: 1)
        return postsLabel
    }()
    lazy var postsButton: UIButton = {
        let postsButton = UIButton()
//        postsButton.frame = CGRect(x: 0, y: 0, width: 72, height: 48)
//        postsButton.setTitle("Posts", for: .normal)
//        postsButton.setTitleColor(.white, for: .normal)
        postsButton.addTarget(self, action: #selector(segmentButtonTouchUpInside), for: .touchUpInside)
        return postsButton
    }()
    private let footPrintLabel: UILabel = {
        let footPrintLabel = UILabel()
        footPrintLabel.text = "FootPrint"
        footPrintLabel.textColor = UIColor(red: 226/255, green: 255/255, blue: 246/255, alpha: 1)
        return footPrintLabel
    }()
    lazy var footPrintButton: UIButton = {
        let footPrintButton = UIButton()
//        footPrintButton.frame = CGRect(x: 0, y: 0, width: 72, height: 48)
//        footPrintButton.setTitle("FootPrint", for: .normal)
//        footPrintButton.setTitleColor(.white, for: .normal)
        footPrintButton.addTarget(self, action: #selector(segmentButtonTouchUpInside), for: .touchUpInside)
        return footPrintButton
    }()
    private let segmentBottomLineBackground: UIView = {
        let segmentBottomLineBackground = UIView()
        segmentBottomLineBackground.backgroundColor = .clear
        return segmentBottomLineBackground
    }()
    private let segmentBottomLine: UIView = {
        let segmentBottomLine = UIView()
        segmentBottomLine.backgroundColor = UIColor(red: 62/255, green: 87/255, blue: 83/255, alpha: 1)
        segmentBottomLine.layer.cornerRadius = 1.5
        return segmentBottomLine
    }()
    
    // MARK: Segment button
    func layoutSegmentControl() {
        
        self.layer.backgroundColor = UIColor.clear.cgColor

        self.contentView.addSubview(stackView)
        postsButton.addSubview(postsLabel)
        footPrintButton.addSubview(footPrintLabel)
        stackView.addArrangedSubview(postsButton)
        stackView.addArrangedSubview(footPrintButton)
        
        postsLabel.snp.makeConstraints { make in
            make.top.equalTo(postsButton).offset(10)
            make.bottom.equalTo(postsButton).offset(-10)
            make.leading.equalTo(postsButton).offset(16)
            make.trailing.equalTo(postsButton).offset(-16)
        }
        
        footPrintLabel.snp.makeConstraints { make in
            make.top.equalTo(footPrintButton).offset(10)
            make.bottom.equalTo(footPrintButton).offset(-10)
            make.leading.equalTo(footPrintButton).offset(16)
            make.trailing.equalTo(footPrintButton).offset(-16)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.contentView).offset(0)
            make.bottom.equalTo(self.contentView).offset(-8)
        }
    
    }
    
    // MARK: Button action
    @objc func segmentButtonTouchUpInside(_ sender: UIButton) {
        
        selectedButton = sender

        let segmentButtonArray = [postsButton, footPrintButton]

        for item in segmentButtonArray {
            
            if item == sender {
                sender.isSelected = true
            } else {
                item.isSelected = false
            }
        }
        
        moveSegmentBottomLine(ofSelectedButton: sender)
        
//        if sender == postsButton{
//
//            productmanager.getProductObject(selectedCategory: .women)
//
//        }else{
//
//            productmanager.getProductObject(selectedCategory: .accessories)
//        }
        
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        segmentBottomLine.frame = CGRect(x: postsButton.frame.minX, y: segmentBottomLine.frame.origin.y, width: postsLabel.frame.width, height: 3)
    }
    
    func layoutSegmentBottomLine() {
        
        self.addSubview(segmentBottomLineBackground)
        segmentBottomLineBackground.addSubview(segmentBottomLine)
        
        segmentBottomLineBackground.translatesAutoresizingMaskIntoConstraints = false
        segmentBottomLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentBottomLineBackground.leadingAnchor.constraint(equalTo: postsLabel.leadingAnchor),
            segmentBottomLineBackground.trailingAnchor.constraint(equalTo: footPrintLabel.trailingAnchor),
            segmentBottomLineBackground.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            segmentBottomLineBackground.heightAnchor.constraint(equalToConstant: 3)
        ])
        
    }
    
    // MARK: 移動 segment 底線的動畫
    func moveSegmentBottomLine(ofSelectedButton: UIButton) {
        
        let widthOfSegmentBottomLine = Double()
        var selectedLabel = UILabel()
        guard let labelOfSegmentButton = ofSelectedButton.subviews[0] as? UILabel else { return }
        
        switch labelOfSegmentButton.text {
        case "Posts":
            selectedLabel = postsLabel
        case "FootPrint":
            selectedLabel = footPrintLabel
        default:
            return
        }
        
        UIView.animate(withDuration: 0.3) { [self] in
            self.segmentBottomLine.frame = CGRect(x: ofSelectedButton.frame.minX, y: segmentBottomLine.frame.origin.y, width: selectedLabel.frame.width, height: 3)
        }
        
    }
    
}
