//
//  AppDelegate.swift
//  PokeAnimations
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
    let intro = Intro(props: Intro.Props(frame: UIScreen.main.bounds))
    self.renderer = Renderer(rootDescription: intro, store: nil)
    self.renderer?.render(in: view)
    
    return true
  }
}
