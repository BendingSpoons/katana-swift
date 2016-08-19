//
//  AppDelegate.swift
//  Demo
//
//  Created by Luca Querella on 13/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana

struct RootLogicState: State {}

enum RootReducer: Reducer {
  static func reduce(action: Action, state: RootLogicState?) -> RootLogicState {
    return RootLogicState()
  }
}

struct ActionOne: Action {
  var actionName = "LQ"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var root: StoreListenerNode<RootReducer>?
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = UIViewController()
    self.window?.rootViewController?.view.backgroundColor = UIColor.white
    self.window?.makeKeyAndVisible()
    
    let view = (self.window?.rootViewController?.view)!
    
    
    let rootBounds = UIScreen.main.bounds
    let rootDescription = App(props: EmptyProps().frame(rootBounds))
    let store = Store(RootReducer.self)
    
    self.root = StoreListenerNode<RootReducer>(store: store, rootDescription: rootDescription)
    self.root!.render(container: RenderContainers(containers: [view]))
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2), execute: {
      store.dispatch(ActionOne())
    })
    
    return true
  }
  
  
}

