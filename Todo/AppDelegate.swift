//
//  AppDelegate.swift
//  Todo
//
//  Created by Ans Riaz on 11/11/2016.
//  Copyright © 2016 Ans Riaz. All rights reserved.
//

import UIKit
import RealmSwift

let realm = try! Realm()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

}

