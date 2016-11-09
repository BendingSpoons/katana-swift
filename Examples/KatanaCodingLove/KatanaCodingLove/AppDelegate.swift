//
//  AppDelegate.swift
//  KatanaCodingLove
//
//  Created by Alain Caltieri on 07/11/16.
//  Copyright © 2016 dk.bendingspoons.Demo. All rights reserved.
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
        
        
        let view = (self.window?.rootViewController?.view)!
        let rootBounds = UIScreen.main.bounds
        
        let store = Store<CodingLoveState>(middlewares: [], dependencies: EmptySideEffectDependencyContainer.self)
        
        self.root = CodingLove(props: CodingLove.Props.build({
            $0.frame = rootBounds
        })).makeRoot(store: store)
        
        store.dispatch(FetchMorePosts(payload: ()))
            
        self.root!.render(in: view)
        
        return true
    }
    

}

