//
//  AppDelegate.swift
//  Demo
//
//  Created by Luca Querella on 13/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var root: Root?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {

    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = UIViewController()
    self.window?.rootViewController?.view.backgroundColor = UIColor.white
    self.window?.makeKeyAndVisible()

    //mineField()
    toDoDemo()

    return true
  }

  private func mineField() {
    let view = (self.window?.rootViewController?.view)!
    let rootBounds = UIScreen.main.bounds
    
    let sideEffects = sideEffectsMiddleware(state: MineFieldState.self, dependencies: nil)
    let actionLogger = actionLoggerMiddleware(state: MineFieldState.self)
    
    let store = Store<SmartReducer<MineFieldState>>(middlewares: [sideEffects, actionLogger])
    
    self.root = MineField(props: MineFieldProps().frame(rootBounds)).root(store: store)
    self.root!.draw(container: view)
    
  }
  
  private func toDoDemo() {
    let view = (self.window?.rootViewController?.view)!
    let rootBounds = UIScreen.main.bounds
    
    let sideEffects = sideEffectsMiddleware(state: ToDoState.self, dependencies: nil)
    let actionLogger = actionLoggerMiddleware(state: ToDoState.self)
    
    let store = Store<SmartReducer<ToDoState>>(middlewares: [sideEffects, actionLogger])
    
    self.root = ToDo(props: ToDoProps().frame(rootBounds)).root(store: store)
    self.root!.draw(container: view)
    
  }
}
