//
//  AppDelegate.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 1/10/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import UIKit

//import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        Metrics.configure()
//
//        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
//        return handled
//    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
//        FBSDKAppEvents.activateApp()
//        ABNScheduler.cancelAllNotifications()
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillResignActive(_ application: UIApplication) {
        MemoryCard.sharedInstance.saveGame()
        self.scheduleNotifications()
    }
    
    func scheduleNotifications() {
//        let alertBody = "Battle awaits in the Arena!".translation()
//        ABNScheduler.schedule(alertBody: alertBody, fireDate: Date().nextDays(1))
//        ABNScheduler.schedule(alertBody: alertBody, fireDate: Date().nextDays(7))
//        ABNScheduler.schedule(alertBody: alertBody, fireDate: Date().nextDays(28))
    }
}
