//
//  AppDelegate.swift
//  momapp
//
//  Created by Sourabh Jamlapuram on 11/26/16.
//  Copyright © 2016 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    /*
     Use this function to add notification support ( this will make the user to ask for permissions for notifications from momapp)
     */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // enabling notifications.
        UIApplication.shared.registerForRemoteNotifications()
        
        let settings = UIUserNotificationSettings(types: [.alert,.badge], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        return true
    }
    
    
    /*
     Use this function to capture the device token (when connected to real device ) as you need to configure aws sns with device token for push notifications.
     */
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // get the device token printed here to configure aws SNS APN nofifications.
        
        print("DEVICE TOKEN = \(deviceToken)")
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print(token)
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        var token2 = String(format: "%@x", deviceToken as CVarArg)
        print(token2)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("Couldn't register: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("notification received")
    }
    
}

