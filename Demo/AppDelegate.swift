//
//  AppDelegate.swift
//  Demo
//
//  Created by Luca Querella on 13/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana

struct RootLogicState: State {
  var showPopup: Bool
  var password: [Int]?
  var counter: Int
}

enum RootReducer: Reducer {
  static func reduce(action: Action, state: RootLogicState?) -> RootLogicState {
    guard let s = state else {
      return RootLogicState(showPopup: true, password: nil, counter: 0)
    }
    
    if action is HidePopup {
      return RootLogicState(showPopup: false, password: s.password, counter: s.counter)
    }
    
    if let a = action as? PinInserted {
      return RootLogicState(showPopup: s.showPopup, password: a.pin, counter: s.counter)
    }
    
    if action is Reset {
      return RootLogicState(showPopup: true, password: nil, counter: s.counter)
    }
    
    if action is IncreaseCounter {
      return RootLogicState(showPopup: s.showPopup, password: s.password, counter: s.counter + 1)
    }
    
    return s
  }
}

struct HidePopup: Action {
  var actionName = "hidePopup"
}

struct Reset: Action {
  var actionName = "Reset"
}

struct PinInserted: Action {
  let actionName = "hidePopup"
  let pin: [Int]
}

struct IncreaseCounter: Action {
  let actionName = "IncreaseCounter"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var root: StoreListenerNode?
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = UIViewController()
    self.window?.rootViewController?.view.backgroundColor = UIColor.white
    self.window?.makeKeyAndVisible()
    
    let view = (self.window?.rootViewController?.view)!
    
    
    let rootBounds = UIScreen.main.bounds
    let rootDescription = App(props: AppProps(section: .Popup, frame: rootBounds))
    let store = Store(RootReducer.self)
    
    self.root = StoreListenerNode(store: store, rootDescription: rootDescription)
    self.root!.render(container: view)//RenderContainers(containers: [view]))
    
    return true
  }
}

