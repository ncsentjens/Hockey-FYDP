//
//  AppDelegate.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-06.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let sessionViewController = SessionViewController()
        sessionViewController.tabBarItem = UITabBarItem(title: "Session",
                                                    image: UIImage(named: "unselected_hockey"),
                                                    selectedImage: UIImage(named: "selected_hockey"))
        
        let statsViewController = StatsViewController(style: .grouped)
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
        
//        CoreDataManager.deleteAllSessionModels()
        
        // Override point for customization after application launch.
        return true
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "SmartSnipe")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


