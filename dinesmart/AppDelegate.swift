//
//  AppDelegate.swift
//  dinesmart
//
//  Created by Mohammed Al-Dahleh on 2019-06-04.
//  Copyright © 2019 Codeovo Software Ltd. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Sentry

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        Client.shared = try? Client(dsn: "https://2dd1b49d5c8c400aaa60e9f2c86214a8@sentry.io/1509662")
        try? Client.shared?.startCrashHandler()
        
        return true
    }
}
