    //
    //  AppDelegate.swift
    //  Lernquiz
    //
    //  Created by Emanuela Trabaldo Lena on 06.01.17.
    //  Copyright © 2017 iOS Praktikum. All rights reserved.
    //
    
    import UIKit
    import Parse
    import Bolts
    
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        
        var window: UIWindow?
        
        
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            // Override point for customization after application launch.
            // ssh -i "/Users/emanuela/Downloads/LernquizKey.pem" ubuntu@35.157.28.174
            // cd parse/htdocs
            // nano server.js startet Server mit richtigen Einstellungen, Daten daraus bezogen
            let configuration = ParseClientConfiguration {
                $0.applicationId = "8d3d7dc06b8564d24d7e478756f41390a0508ed2"
                $0.clientKey = "341bee5061a2266364917e7c1d80b05c3ddf1a9a"
                $0.server = "http://ec2-35-157-28-174.eu-central-1.compute.amazonaws.com:80/parse"
            }
            Parse.initialize(with: configuration)
            
            // Wird fuer Login benoetigt, setzt Standardrechte fuer User
            PFUser.enableAutomaticUser()
            let defaultACL = PFACL()
            defaultACL.getPublicReadAccess = true
            PFACL.setDefault(defaultACL, withAccessForCurrentUser: true)
            
            
            // Objekte werden im Server erstellt und gespeichert
            let testObject = PFObject(className: "General")
            testObject["Name"] = "bar"
            do{
                try testObject.save()
            } catch {}
            return true
        }
        
        func applicationWillResignActive(_ application: UIApplication) {
            // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
            // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        }
        
        func applicationDidEnterBackground(_ application: UIApplication) {
            // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
            // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        }
        
        func applicationWillEnterForeground(_ application: UIApplication) {
            // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        }
        
        func applicationDidBecomeActive(_ application: UIApplication) {
            // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        }
        
        func applicationWillTerminate(_ application: UIApplication) {
            // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        }
    }
