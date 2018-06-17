//
//  AppDelegate.swift
//  WebviewApp
//
//  Created by 심 승민 on 2018. 6. 18..
//  Copyright © 2018년 심 승민. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()

        let viewController = ViewController()
        window.rootViewController = viewController

        StatusBar.setBackgroundColor(.white)

        return true
    }

}
