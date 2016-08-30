//
//  AppDelegate.swift
//  Demo
//
//  Created by Luca Querella on 13/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana

struct EmptyAppState: State {}

enum EmptyReducer: Reducer {
  static func reduce(action: Action, state: EmptyAppState) -> EmptyAppState {
    return EmptyAppState()
  }
}



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var root: RootNode?
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = UIViewController()
    self.window?.rootViewController?.view.backgroundColor = UIColor.white
    self.window?.makeKeyAndVisible()
    
    let view = (self.window?.rootViewController?.view)!
    let rootBounds = UIScreen.main.bounds

    
//    [(Store<EmptyReducer>) -> (StoreDispatch) -> (Action) -> Void]
//    
//    [(Store<_>) -> (StoreDispatch) -> (Action) -> Void]'
//    
    
    let middlewares = [sagaMiddleware(reducer: EmptyReducer.self)]
    let store = Store(middlewares: middlewares)
    
    self.root = App(props: AppProps().frame(rootBounds)).node(store: store)
    self.root!.draw(container: view)
    
    return true
  }
}

