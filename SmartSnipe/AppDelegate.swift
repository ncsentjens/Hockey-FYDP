//
//  AppDelegate.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-06.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let netViewController = NetViewController()
        netViewController.tabBarItem = UITabBarItem(title: "Net",
                                                    image: nil,
                                                    selectedImage: nil)
        
        let statsViewController = StatsViewController()
        statsViewController.tabBarItem = UITabBarItem(title: "Stats",
                                                      image: nil,
                                                      selectedImage: nil)
        
        let settingsViewController = SettingsViewController()
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings",
                                                         image: nil,
                                                         selectedImage: nil)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [netViewController, statsViewController, settingsViewController]
        
        tabBarController.selectedViewController = netViewController
        tabBarController.selectedIndex = 0
        
        self.window?.rootViewController = tabBarController
        
        // Override point for customization after application launch.
        return true
    }
}

