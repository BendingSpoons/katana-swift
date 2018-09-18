//
//  AppDelegate.swift
//  Demo
//
//  Copyright © 2018 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import UIKit
import Katana

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var store: Store<AppState>?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    
    let actionLogger: StoreMiddleware = ActionLogger.middleware(blackList: [
      DecrementCounter.self
      ])
    let store = Store<AppState>(middleware: [actionLogger], dependencies: AppDependenciesContainer.self)
    self.store = store
    
    self.window?.rootViewController = CounterViewController(store: store)
    self.window?.makeKeyAndVisible()
    
    return true
  }
}
