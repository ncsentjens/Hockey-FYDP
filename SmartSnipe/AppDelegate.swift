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
        
        let sessionViewController = SessionViewController()
        sessionViewController.tabBarItem = UITabBarItem(title: "Session",
                                                    image: UIImage(named: "unselected_hockey"),
                                                    selectedImage: UIImage(named: "selected_hockey"))
        
        let statsViewController = StatsViewController()
        statsViewController.tabBarItem = UITabBarItem(title: "Stats",
                                                      image: UIImage(named: "unselected_stats"),
                                                      selectedImage: UIImage(named: "selected_stats"))
        
        let settingsViewController = SettingsViewController()
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings",
                                                         image: UIImage(named: "unselected_settings"),
                                                         selectedImage: UIImage(named: "selected_settings"))
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers =
            [UINavigationController(rootViewController:sessionViewController),
             UINavigationController(rootViewController: statsViewController),
             UINavigationController(rootViewController: settingsViewController)]
        
        tabBarController.selectedIndex = 0
        tabBarController.tabBar.barTintColor = .black
        tabBarController.tabBar.tintColor = SSColors.grainYellow
        tabBarController.tabBar.unselectedItemTintColor = .gray
        
        self.window?.rootViewController = tabBarController
        
        // Override point for customization after application launch.
        return true
    }
}


