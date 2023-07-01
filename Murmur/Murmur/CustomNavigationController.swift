//
//  CustomNavigationController.swift
//  Murmur
//
//  Created by cleopatra on 2023/7/1.
//

import Foundation
import UIKit

class CustomNavigationController: UINavigationController {
    
    
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        let navBarAppearance = UINavigationBarAppearance()
        
        navBarAppearance.configureWithDefaultBackground()
        navBarAppearance.backgroundColor = .PrimaryDefault
        navBarAppearance.backgroundEffect = UIBlurEffect(style: .regular)
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.GrayScale20,
            .font: UIFont.systemFont(ofSize: 18, weight: .medium)
        ]
        self.navigationBar.tintColor = .GrayScale20
        self.navigationBar.layer.addWhiteShadow()
        self.navigationBar.standardAppearance = navBarAppearance
        self.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem?.tintColor = .SecondaryShine
        navigationItem.leftBarButtonItem?.tintColor = .SecondaryDefault
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
