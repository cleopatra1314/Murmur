//
//  SceneDelegate.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/14.
//

import UIKit

// swiftlint:disable line_length
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // MARK: - 實例化 window
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        // MARK: - 讓 window 顯示
        self.window?.makeKeyAndVisible()
        
        // 创建 TabBarController
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .lightGray
        
        // 创建视图控制器
        let firstViewController = HomePageViewController()
        let secondViewController = ChatViewController()
        let thirdViewController = PostViewController()
        let fourthViewController = ProfileViewController()
        
        // 将视图控制器添加到 TabBarController
        let thirdNavigationController = UINavigationController(rootViewController: thirdViewController)
        let secondNavigationController = UINavigationController(rootViewController: secondViewController)
        tabBarController.viewControllers = [firstViewController, secondNavigationController, thirdNavigationController, fourthViewController]
        
//        tabBarController.viewControllers?[2] = thirdNavigationController

        // 设置 TabBarController 为根视图控制器
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        // 設定 tabBarItem
        if let tabBarItems = tabBarController.tabBar.items {
            
            let homeTabBarItem: UITabBarItem = {
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
            
//            let thirdNavigationController = UINavigationController(rootViewController: thirdViewController)
            
        }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    //
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print("連結到 app", URLContexts)
    }

}

// swiftlint:enable line_length
