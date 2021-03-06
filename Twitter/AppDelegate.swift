//
//  AppDelegate.swift
//  Twitter
//
//  Created by Sarn Wattanasri on 2/3/16.
//  Copyright © 2016 Sarn. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard = UIStoryboard(name: "Main", bundle: nil)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        initializeTabBar()
        
        //Subscribe to userDidLogout event
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidLogout", name: userDidLogoutNotification, object: nil)
        
        //Check if there is a current user
        if let user =  User.currentUser {
            user.logout()
            let vc = storyboard.instantiateViewControllerWithIdentifier("TweetsViewController") as! UINavigationController
            
            window?.rootViewController = vc
            
            
        }
        return true
    }
    
    func userDidLogout() {
        //use the initial ViewController
        let vc = storyboard.instantiateInitialViewController()! as UIViewController
        window?.rootViewController = vc
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
    
    //result of the oauth request - after coming back from Twitter authorization - token obtained
    @available(iOS, deprecated=8.0) //suppress warning on deprecated openURL() method
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        TwitterClient.sharedInstance.openURL(url)
        return true
    }
    
    
    func initializeTabBar() {
        //first tab item
        let tweetsViewController = storyboard.instantiateViewControllerWithIdentifier("TwitterNavigationController") as! UINavigationController
        tweetsViewController.tabBarItem.title = "Timeline"
        tweetsViewController.tabBarItem.image = UIImage(named: "TimelineIcon")
        
        //second tab item
        let profileViewController = storyboard.instantiateViewControllerWithIdentifier("MeViewController")
        profileViewController.tabBarItem.title = "Me"
        profileViewController.tabBarItem.image = UIImage(named: "MeIcon")
        
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [tweetsViewController, profileViewController]
         tabBarController.tabBar.barTintColor = UIColor.whiteColor()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }


}

