//
//  AppDelegate.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/14.
//

import UIKit
import FirebaseCore
import IQKeyboardManagerSwift

// swiftlint:disable line_length
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var timer = Timer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
            
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
     
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    // App 進到背景模式
    func applicationDidEnterBackground(_ application: UIApplication) {
  
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("用戶已離線")
    }
}

// swiftlint:enable line_length
