//
//  AppDelegate.swift
//  ATRealmDatabase_Demo
//
//  Created by Dejan on 11/03/2018.
//  Copyright © 2018 Dejan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        printDocumentsDirectory()
        return true
    }
    
    private func printDocumentsDirectory() {
        let fileManager = FileManager.default
        if let documentsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last {
            print("Documents directory: \(documentsDir.absoluteString)")
        } else {
            print("Error: Couldn't find documents directory")
        }
    }
}

