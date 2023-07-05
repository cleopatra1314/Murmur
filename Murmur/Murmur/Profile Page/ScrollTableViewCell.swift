//
//  ScrollTableViewCell.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/28.
//

import Foundation
import UIKit
import SnapKit

class ScrollTableViewCell: UITableViewCell {
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .PrimaryDefault
        scrollView.contentSize = CGSize(width: fullScreenSize.width * 2, height: 0)
        return scrollView
    }()
    let postsVC = PostsViewController()
    let footPrintVC = FootPrintViewController()

    func layoutView(viewController: UIViewController) {
        
        self.contentView.addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView.safeAreaLayoutGuide)
        }

        viewController.addChild(postsVC)
        scrollView.addSubview(postsVC.view)
//        postsVC.didMove(toParent: viewController)

        viewController.addChild(footPrintVC)
        scrollView.addSubview(footPrintVC.view)
//        footPrintVC.didMove(toParent: viewController)
        
        postsVC.view.translatesAutoresizingMaskIntoConstraints = false
        footPrintVC.view.translatesAutoresizingMaskIntoConstraints = false

        // 第一個視圖控制器的視圖
        postsVC.view.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor).isActive = true
        postsVC.view.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
        postsVC.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive = true
        postsVC.view.heightAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.heightAnchor).isActive = true

        // 第二個視圖控制器的視圖
        footPrintVC.view.leadingAnchor.constraint(equalTo: postsVC.view.trailingAnchor).isActive = true
        footPrintVC.view.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
        footPrintVC.view.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor).isActive = true
        footPrintVC.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive = true
        footPrintVC.view.heightAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.heightAnchor, constant: -180).isActive = true
        
    }
    
}
