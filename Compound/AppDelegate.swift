//
//  AppDelegate.swift
//  Compound
//
//  Created by Daniel Maness on 4/15/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import UIKit
import Parse
import Bolts
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios_guide#localdatastore/iOS
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("KvM7iXZLzcYwKY2Gr7DCd5oj5v2k2knTzsQ9m5Pc",
            clientKey: "wiTG8xjvxR2PuhH7XafhFMxX1UARhZCx2swodFyc")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
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
        FBSDKAppEvents.activateApp()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let cfBundleVersion = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as! String
        if userDefaults.valueForKey("version") == nil {
            copyFile("compound.sqlite")
            userDefaults.setObject(cfBundleVersion, forKey: "version")
        }
        
        if NSUserDefaults.standardUserDefaults().stringForKey("version") != cfBundleVersion {
            copyFile("compound.sqlite")
            userDefaults.setObject(cfBundleVersion, forKey: "version")
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func applicationDidFinishLaunching(application: UIApplication) {
        copyFile("compound.sqlite")
    }
    
    func copyFile(fileName: NSString) {
        let dbPath: String = getPath(fileName as String)
        let fileManager = NSFileManager.defaultManager()
        let documentsURL = NSBundle.mainBundle().resourceURL
        let fromPath = documentsURL!.URLByAppendingPathComponent(fileName as String)
        do {
            try fileManager.copyItemAtPath(fromPath.path!, toPath: dbPath)
        } catch let error as NSError {
            EventService.logError(error, description: "Could not copy database", object: "AppDelegate", function: "copyFile")
        }
    }
    
    func getPath(fileName: String) -> String {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documentsURL.URLByAppendingPathComponent(fileName)
        return fileURL.path!
    }
}

