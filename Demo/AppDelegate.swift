//
//  AppDelegate.swift
//  Demo
//
//  Created by Mauro Bolis on 19/02/2018.
//  Copyright © 2018 Mauro Bolis. All rights reserved.
//

import UIKit
import Katana

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var store: Store<AppState>?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    let store = Store<AppState>(middleware: [], dependencies: AppDependenciesContainer.self)
    self.store = store

    self.window?.rootViewController = CounterViewController(store: store)
    self.window?.makeKeyAndVisible()
    
    return true
  }
}

