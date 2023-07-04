//
//  SceneDelegate.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/14.
//

import UIKit
import FirebaseAuth

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
        
        if let user = Auth.auth().currentUser {
            // 如果已經登入，直接到首頁
            currentUserUID = user.uid
            
            // Modify user onlineState
            database.collection("userTest").document(currentUserUID).getDocument { documentSnapshot, error in
                
                guard let documentSnapshot,
                      documentSnapshot.exists,
                      var user = try? documentSnapshot.data(as: Users.self)
                else {
                    return
                }
                
                user.onlineState = true
                
                do {
                    try database.collection("userTest").document(currentUserUID).setData(from: user)
                } catch {
                    print(error)
                }
                
            }
            
            let customTabBarController = CustomTabBarController()
            
            // 设置 TabBarController 为根视图控制器
            window?.rootViewController = customTabBarController
            
        } else {
            
            // 如果尚未登入，先到登入 / 註冊頁
            let initialVC = InitialViewController()
            let initialNavigationController = CustomNavigationController(rootViewController: initialVC)
            
            window?.rootViewController = initialNavigationController
            
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
