//
//  AppDelegate.swift
//  Warmshowers
//
//  Created by admin on 07/05/15.
//  Copyright (c) 2015 mihaeu. All rights reserved.
//

import UIKit
import XCGLogger
import CoreData
import RealmSwift
import Haneke

let log = XCGLogger.defaultInstance()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        setUpLog()
        setUpRealm()
        setUpInitialViewController()

        return true
    }

    /**
        Set up XCGLogger format, colors etc.
    */
    private func setUpLog()
    {
        log.setup(
            logLevel: .Debug,
            showLogLevel: true,
            showFileNames: true,
            showLineNumbers: true,
            writeToFile: nil,
            fileLogLevel: .Debug
        )

        log.xcodeColorsEnabled = true
        log.xcodeColors = [
            .Verbose: .lightGrey,
            .Debug: .darkGrey,
            .Info: .blue,
            .Warning: .orange,
            .Error: .red
        ]

    }

    /**
        Set up Realm migrations.
    */
    private func setUpRealm()
    {
        log.debug("Default Realm database at: \(Realm.defaultPath)")

        // Reset Realm database by deleting it
        // var error: NSError?
        // NSFileManager.defaultManager().removeItemAtPath(Realm.defaultPath, error: &error)

        // or migrate:
        setSchemaVersion(16, Realm.defaultPath, { migration, oldSchemaVersion in })
    }

    /**
        Set up initial view controller depending on login status.
    */
    private func setUpInitialViewController()
    {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        // NOT logged in
        if UserRepository.sharedInstance.findByActiveUser() == nil {
            self.window?.rootViewController =
                storyboard.instantiateViewControllerWithIdentifier("Authentication") as? UIViewController
        // otherwise send to map
        } else {
            self.window?.rootViewController =
                storyboard.instantiateViewControllerWithIdentifier("Map") as? UIViewController
        }
        self.window?.makeKeyAndVisible()
    }
}
