//
//  AppDelegate.swift
//  Minesweeper
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import UIKit
import Katana


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var renderer: Renderer?
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    UIApplication.shared.isStatusBarHidden = true
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = UIViewController()
    self.window?.makeKeyAndVisible()
    
    let view = self.window!.rootViewController!.view!
    let store = Store<MinesweeperState>()
    let minesweeper = Minesweeper(props: Minesweeper.Props.build({
      $0.frame = UIScreen.main.bounds
    }))
    self.renderer = Renderer(rootDescription: minesweeper, store: store)
    self.renderer?.render(in: view)
    
    return true
  }
}
