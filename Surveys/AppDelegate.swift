//
//  AppDelegate.swift
//  Surveys
//
//  Created by Trung Vo on 7/23/20.
//  Copyright © 2020 Trung Vo. All rights reserved.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupNavigationBarAppearance()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// MARK: Support Methods
extension AppDelegate {
    func setupNavigationBarAppearance() {
        let navigationBarAppearace = UINavigationBar.appearance()
        let color = UIColor(red: 19/255.0, green: 30/255.0, blue: 52/255.0, alpha: 1)
        let font = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
        
        navigationBarAppearace.tintColor = .white
        navigationBarAppearace.isTranslucent = false
        navigationBarAppearace.barTintColor = color
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                      NSAttributedString.Key.font: font]
    }
}
