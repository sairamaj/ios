//
//  AppDelegate.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 11/30/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // launch image info is described here: http://www.idev101.com/code/User_Interface/launchImages.html
        
        // http://codewithchris.com/using-parse-swift-xcode-6/
        
        let reachability = Reachability.reachabilityForInternetConnection()
        
        if reachability.isReachable(){
            println("network is avilable")
        }else{
            println("network isn not reachable")
            UserAlerts.showMessageForNoNetwork()
        }
        
        reachability.whenReachable = { reachability in
            if reachability.isReachableViaWiFi() {
                println("Reachable via WiFi")
            } else {
                println("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { reachability in
             UserAlerts.showMessageForNoNetwork()
        }
        
        reachability.startNotifier()
        
       window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let containerViewController = ContainerViewController()
        
        window!.rootViewController = containerViewController
        window!.makeKeyAndVisible()

        
        // app keys for sj account
        //Parse.setApplicationId("AgaW8JJzu4u5g5Sd2dBLrrZBoLlSqgBjFPCnZaqj", clientKey: "XWGzu59jSdzxSkHHzxqYoRR3vgvuJUM2bhNYaAhI")
        
        // app keys fop afoofa
        Parse.setApplicationId("kZegFT6aNhguJ9Jk1EgWPCTvtPMEyK8GQQoJ8NFP", clientKey: "9GehqK2lHLwKrRllZnlKJM63NsyvSQ8zXbuQhysq")
        
        Repository.Instance.loadScouts()
        Repository.Instance.loadTournaments()

        sleep(3)       // splash screen will stay this longer.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasksdi, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

