//
//  HeaderOfCollectionView.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/26.
//

import Foundation
import UIKit

class HeaderOfCollectionView: UICollectionViewCell {
    
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
        postsLabel.textColor = .white
        return postsLabel
    }()
    private let postsButton: UIButton = {
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
        footPrintLabel.textColor = .white
        return footPrintLabel
    }()
    private let footPrintButton: UIButton = {
        let footPrintButton = UIButton()
//        footPrintButton.frame = CGRect(x: 0, y: 0, width: 72, height: 48)
//        footPrintButton.setTitle("FootPrint", for: .normal)
//        footPrintButton.setTitleColor(.white, for: .normal)
        footPrintButton.addTarget(self, action: #selector(segmentButtonTouchUpInside), for: .touchUpInside)
        return footPrintButton
    }()
    private let segmentBottomLineBackground = UIView()
    private let segmentBottomLine = UIView()
    
    
    //MARK: Segment button
    func layoutSegmentControl(){

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
            make.centerX.equalTo(self)
        }
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    
    }
    
    //MARK: Button action
    @objc func segmentButtonTouchUpInside(_ sender: UIButton){
        
        selectedButton = sender

        let segmentButtonArray = [postsButton, footPrintButton]

        for item in segmentButtonArray{
            
            if item == sender{
                sender.isSelected = true
            }else{
                item.isSelected = false
            }
        }
        
        //TODO: 設定 bottom line 跟著 button 跑
        layoutSegmentBottomLine(ofSelectedButton: sender)
        
//        if sender == postsButton{
//
//            productmanager.getProductObject(selectedCategory: .women)
//
//        }else{
//
//            productmanager.getProductObject(selectedCategory: .accessories)
//        }
        
    }
    
    func layoutSegmentBottomLine(ofSelectedButton: UIButton){
        
        self.addSubview(segmentBottomLineBackground)
        segmentBottomLineBackground.addSubview(segmentBottomLine)
        
        segmentBottomLineBackground.backgroundColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        segmentBottomLine.backgroundColor = .black
        
        segmentBottomLineBackground.translatesAutoresizingMaskIntoConstraints = false
        segmentBottomLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentBottomLineBackground.leadingAnchor.constraint(equalTo: postsLabel.leadingAnchor),
            segmentBottomLineBackground.trailingAnchor.constraint(equalTo: footPrintLabel.trailingAnchor),
            segmentBottomLineBackground.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            segmentBottomLineBackground.heightAnchor.constraint(equalToConstant: 2),
            
            //??
            segmentBottomLine.widthAnchor.constraint(equalTo: postsLabel.widthAnchor, multiplier: 1),
            segmentBottomLine.topAnchor.constraint(equalTo: segmentBottomLineBackground.topAnchor),
            segmentBottomLine.bottomAnchor.constraint(equalTo: segmentBottomLineBackground.bottomAnchor),
            //segmentBottomLine.heightAnchor.constraint(equalToConstant: 3),
            //?? segmentBottomLine.centerXAnchor.constraint(equalTo: selectedButton.centerXAnchor)
            
        ])
        segmentBottomLine.center.x = ofSelectedButton.center.x
        print(segmentBottomLine.center.x)
        
    }
    
    //MARK: 移動 segment 底線的動畫
    func moveSegmentBottomLine(ofSelectedButton: UIButton){
        
        let widthOfSegmentBottomLine = Double()
        var selectedLabel = UILabel()
        
        switch ofSelectedButton.title(for: .normal) {
        case "Posts":
            selectedLabel = postsLabel
        case "FootPrint":
            selectedLabel = footPrintLabel
        default:
            return
        }
        
        UIView.animate(withDuration: 0.4) { [self] in
            self.segmentBottomLine.frame = CGRect(x: ofSelectedButton.frame.minX, y: segmentBottomLine.frame.origin.y, width: selectedLabel.frame.width, height: 1)
        }
        //         segmentBottomLine.center.x = ofSelectedButton.center.x
        print(segmentBottomLine.center.x)
        
    }
    
    
}
