//
//  AppDelegate.swift
//  NewsApp
//
//  Created by Alex Rudoi on 9/8/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DatabaseManager.shared.clearDatabase()
        
        setUserDefaults()
        
        return true
    }


}

