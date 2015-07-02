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

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
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

        log.info("Default Realm database at: \(Realm.defaultPath)")
        setSchemaVersion(9, Realm.defaultPath, { migration, oldSchemaVersion in
            // We haven’t migrated anything yet, so oldSchemaVersion == 0
//            if oldSchemaVersion < 1 {
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
//            }
        })
        
        return true
    }
}
