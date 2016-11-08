//
//  AppDelegate.swift
//  Demo
//
//  Created by Andrea De Angelis on 08/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana
import KatanaElements
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var root: Root?
  
  
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
    self.root = CounterScreen(props: CounterScreenProps.build({ (counterScreenProps) in
      counterScreenProps.frame = rootBounds
    })).makeRoot(store: store)
    self.root!.render(in: view)
    
    
    /*let store = Store<SmartReducer<ToDoState>>(middlewares: [sideEffects, actionLogger])
     
     self.root = ToDo(props: ToDoProps().frame(rootBounds)).root(store: store)
     self.root!.draw(container: view)
     */
  }
  
}
