//
//  AppDelegate.swift
//  Demo
//
//  Created by Andrea De Angelis on 09/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana
import KatanaElements
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var renderer: Renderer?
  
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = UIViewController()
    self.window?.rootViewController?.view.backgroundColor = UIColor.white
    self.window?.makeKeyAndVisible()
    
    counterDemo()
    return true
  }
  
  private func counterDemo() {
    let view = (self.window?.rootViewController?.view)!
    let rootBounds = UIScreen.main.bounds
    
    let store = Store<CounterState>()
    let counterScreen = CounterScreen(props: CounterScreenProps.build({ (counterScreenProps) in
      counterScreenProps.frame = rootBounds
    }))
    
    renderer = Renderer(rootDescription: counterScreen, store: store)
    renderer!.render(in: view)
  }
  
}
