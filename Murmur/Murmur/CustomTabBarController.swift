//
//  CustomTabBarController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/30.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        createTabBar()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createTabBar() {
        let barAppearance = UITabBarAppearance()
        
        //        barAppearance.configureWithDefaultBackground()
        //        barAppearance.configureWithOpaqueBackground()
        barAppearance.configureWithTransparentBackground()
        
        //        let blurEffect = UIBlurEffect(style: .light)
        //        let blurView = UIVisualEffectView(effect: blurEffect)
        //        blurView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        //        self.tabBarController?.tabBar.insertSubview(blurView, at: 0)
        
        barAppearance.backgroundEffect = UIBlurEffect(style: .prominent)
        //        barAppearance.backgroundImage = UIImage()
        //        barAppearance.shadowColor = .clear
        
        // 創建UIVisualEffectView
        //        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        
        // 設置frame為整個UITabBar的範圍
        //        visualEffectView.frame = (self.tabBarController?.tabBar.bounds)!
        
        //        self.tabBar.backgroundImage = UIImage()
        //        self.tabBar.shadowImage = UIImage()
        
        barAppearance.backgroundColor = .PrimaryMidDark
//
        barAppearance.stackedLayoutAppearance.normal.iconColor = .SecondaryMiddle
        barAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.SecondaryMiddle,
            .font: UIFont.systemFont(ofSize: 10)
        ]
        barAppearance.stackedLayoutAppearance.selected.iconColor = .SecondaryShine
        barAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.SecondaryShine,
            .font: UIFont.systemFont(ofSize: 10)
        ]
        
        // 缺一不可
        self.tabBar.layer.addBarShadow()
        self.tabBar.standardAppearance = barAppearance
        self.tabBar.scrollEdgeAppearance = barAppearance
       
        // 创建视图控制器
        let firstViewController = HomePageViewController()
        let secondViewController = ChatViewController()
        let thirdViewController = PostViewController()
        let fourthViewController = ProfileViewController()
        
        // 将视图控制器添加到 TabBarController
        let secondNavigationController = CustomNavigationController(rootViewController: secondViewController)
        let thirdNavigationController = CustomNavigationController(rootViewController: thirdViewController)
        self.viewControllers = [firstViewController, secondNavigationController, thirdNavigationController, fourthViewController]
        
        // 設定 tabBarItem
        if let tabBarItems = self.tabBar.items {
            
            let _: UITabBarItem = {
                // 根据索引找到目标 TabBarItem
                let homeTabBarItem = tabBarItems[0]
                // 修改 TabBarItem 的属性
                homeTabBarItem.title = "首頁"
                homeTabBarItem.image = UIImage(named: "Icons_Home.png")
                return homeTabBarItem
            }()
            
            let _: UITabBarItem = {
                // 根据索引找到目标 TabBarItem
                let chatRoomTabBarItem = tabBarItems[1]
                // 修改 TabBarItem 的属性
                chatRoomTabBarItem.title = "聊天"
                chatRoomTabBarItem.image = UIImage(named: "Icons_ChatRoom.png")
                return chatRoomTabBarItem
            }()
            
            let _: UITabBarItem = {
                // 根据索引找到目标 TabBarItem
                let postTabBarItem = tabBarItems[2]
                // 修改 TabBarItem 的属性
                postTabBarItem.title = "塗鴉"
                postTabBarItem.image = UIImage(named: "Icons_Post.png")
                return postTabBarItem
            }()
            
            let _: UITabBarItem = {
                // 根据索引找到目标 TabBarItem
                let profileTabBarItem = tabBarItems[3]
                // 修改 TabBarItem 的属性
                profileTabBarItem.title = "個人"
                profileTabBarItem.image = UIImage(named: "Icons_Profile.png")
                return profileTabBarItem
            }()
        }
        self.modalPresentationStyle = .fullScreen
        self.modalTransitionStyle = .crossDissolve
        
    }
    
    // 以下還是會受系統自動調整背景色而影響
    //        tabBarController.tabBar.isTranslucent = false
    //        tabBarController.tabBar.backgroundColor = .PrimaryDark
    //        tabBarController.tabBar.tintColor = .SecondaryShine
    //        tabBarController.tabBar.unselectedItemTintColor = .SecondaryMiddle
    
}
