//
//  AppDelegate.swift
//  Example
//
//  Created by Md. Siam Biswas on 10/5/20.
//  Copyright © 2020 siambiswas. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var widhow:UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow()
        window.rootViewController = UINavigationController(rootViewController: ViewController())
        window.makeKeyAndVisible()
        self.widhow = window
        
        return true
    }




}

