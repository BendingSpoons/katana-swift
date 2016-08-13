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


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UIViewController()
        self.window?.rootViewController?.view.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
        let view = (self.window?.rootViewController?.view)!
        let view1 = UIView(frame: CGRect(x:0,y:0,width:250, height:250))
        view1.layer.borderColor = UIColor.green.cgColor
        view1.layer.borderWidth = 2
        view.addSubview(view1)
        
        let view2 = UIView(frame: CGRect(x:0,y:300,width:250, height:250))
        view2.layer.borderColor = UIColor.red.cgColor
        view2.layer.borderWidth = 2
        view.addSubview(view2)
        
        
        let profiler = RenderProfiler() { print($0) }
        
        
        let root = App(props: EmptyProps().frame(0,0,220,220), children: [])
        
        root.node().render(container: RenderContainers(containers: [view1,view2,profiler]))
        
        return true
    }


}

