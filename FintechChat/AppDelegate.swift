//
//  AppDelegate.swift
//  FintechChat
//
//  Created by Ирина Улитина on 07/02/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /*var previousState: String = "Not running"
    var currentState: String = ""*/
    
    var stateLogger: StateLogger = StateLogger(startState: "Not running", callerName: "Application")
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //printState(currState: "Inactive", methodName: #function)
        stateLogger.moveToNewState(newState: "Inactive")
        
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().isTranslucent = false

        
        window = UIWindow()
        window?.makeKeyAndVisible()
        let navController = CustomNavigationController(rootViewController: ConversationListViewController())
        window?.rootViewController = navController
        
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        stateLogger.moveToNewState(newState: "Inactive")
        //printState(currState: "Inactive", methodName: #function)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
        stateLogger.moveToNewState(newState: "Background")

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        stateLogger.moveToNewState(newState: "Inactive")

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        stateLogger.moveToNewState(newState: "Active")

    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
        stateLogger.moveToNewState(newState: "Suspended")
        //printState(currState: "Suspended", methodName: #function)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "FintechChat")
        container.loadPersistentStores(completionHandler: { (_, error) in
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
