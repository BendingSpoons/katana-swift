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

//    mineField()
    toDoDemo()

    return true
  }

  private func mineField() {
    let view = (self.window?.rootViewController?.view)!
    let rootBounds = UIScreen.main.bounds
    
    let actionLogger = actionLoggerMiddleware(MineFieldState.self)
    let store = Store<MineFieldState>(middlewares: [actionLogger], dependencies: EmptySideEffectDependencyContainer.self)
    
    self.root = MineField(props: MineFieldProps().frame(rootBounds)).makeRoot(store: store)
    self.root!.draw(container: view)
    
  }
  
  private func toDoDemo() {
    let view = (self.window?.rootViewController?.view)!
    let rootBounds = UIScreen.main.bounds
    
    let actionLogger = actionLoggerMiddleware(ToDoState.self)
    let store = Store<ToDoState>(middlewares: [actionLogger], dependencies: EmptySideEffectDependencyContainer.self)
    
    self.root = ToDo(props: ToDoProps().frame(rootBounds)).makeRoot(store: store)
    self.root!.draw(container: view)
  }
}
