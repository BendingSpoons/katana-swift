//
//  AppDelegate.swift
//  HackerNewsClient
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
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UIViewController()
        self.window?.rootViewController?.view.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
        let view = (self.window?.rootViewController?.view)!
        
        let store = Store<HackerNewsState>(middlewares: [], dependencies: PostsProvider.self)
        
        self.renderer = Renderer(rootDescription: HackerNews(props: HackerNews.Props.build({
            $0.frame = UIScreen.main.bounds
        })), store: store)
        
        store.dispatch(Reload(payload: ()))
        
        self.renderer!.render(in: view)
        
        return true
    }

}
