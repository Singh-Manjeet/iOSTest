//
//  AppDelegate.swift
//  LandmarkRemark
//
//  Created by Manjeet Singh on 27/5/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Launcher.launch(with: window)
        return true
    }
}

