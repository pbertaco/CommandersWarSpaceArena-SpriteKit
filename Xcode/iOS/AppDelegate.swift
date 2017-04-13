//
//  AppDelegate.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 1/10/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import UIKit

import FBSDKCoreKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Metrics.configure()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        ABNScheduler.cancelAllNotifications()
        
        if #available(iOS 10.0, *) {
            let authorizationOptions: UNAuthorizationOptions = [.badge, .sound, .alert]
            UNUserNotificationCenter.current().requestAuthorization(options: authorizationOptions) { (granted: Bool, error: Error?) in
                
            }
        } else {
            let userNotificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            application.registerUserNotificationSettings(userNotificationSettings)
        }
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        return handled
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
        ABNScheduler.cancelAllNotifications()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        MemoryCard.sharedInstance.saveGame()
        self.scheduleNotifications()
    }
    
    func scheduleNotifications() {
        let alertBody = "Battle awaits in the Arena!".translation()
        ABNScheduler.schedule(alertBody: alertBody, fireDate: Date().nextDays(1))
        ABNScheduler.schedule(alertBody: alertBody, fireDate: Date().nextDays(7))
        ABNScheduler.schedule(alertBody: alertBody, fireDate: Date().nextDays(30))
    }
}
