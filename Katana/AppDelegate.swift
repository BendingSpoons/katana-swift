//
//  AppDelegate.swift
//  Katana
//
//  Created by Luca Querella on 02/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UIViewController()
        self.window?.rootViewController?.view.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
        let view = (self.window?.rootViewController?.view)!
        let view1 = UIView(frame: CGRect(x:0,y:0,width:200, height:200))
        view1.layer.borderColor = UIColor.green.cgColor
        view1.layer.borderWidth = 2
        view.addSubview(view1)

        let view2 = UIView(frame: CGRect(x:0,y:300,width:200, height:200))
        view2.layer.borderColor = UIColor.red.cgColor
        view2.layer.borderWidth = 2
        view.addSubview(view2)

        
        let profiler = RenderProfiler() { print($0) }
        
        let root = K(App(), props: AppProps())

        root.node().render(on: RenderContainers(containers: [view1,view2,profiler]))
  
        return true
    }
}


//------------------------------------//

struct AppState: Equatable {
    var i = 0
    
    static func ==(lhs: AppState, rhs: AppState) -> Bool {
        return true
    }
}


struct AppProps: Equatable {
    static func ==(lhs: AppProps, rhs: AppProps) -> Bool {
        return false
    }
}

struct App : Logic {
  
    static let initialState = 0
    
    static func logic(state: Int,
                      props: AppProps,
                      update: (Int)->()
        ) -> NodeDescription {
        

        if (state == 0) {
            return K(View(), props: ViewProps().frame(0,0,150,150).color(.gray))([
                K(Button(), props: ButtonsProps()
                    .frame(50,50,100,100)
                    .color(.orange)
                    .text("state 0")
                    .onTap({ update(1) })
                    )([])
                ])
            
        } else if (state == 1) {
            return K(View(), props: ViewProps().frame(0,0,150,150).color(.blue))([
                K(View(), props: ViewProps().frame(0,0,70,70).color(.red))([]),
                
                K(Button(), props: ButtonsProps()
                    .frame(50,50,100,100)
                    .color(.orange)
                    .text("state 1")
                    .onTap({ update(2) })
                    )([]),
                ])
        } else if (state == 2) {
            return K(View(), props: ViewProps().frame(0,0,150,150).color(.green))([
                K(Button(), props: ButtonsProps()
                    .frame(40,40,100,100)
                    .color(.orange)
                    .text("state 2")
                    .onTap({ update(3) })
                    )([]),
                K(View(), props: ViewProps().frame(0,0,50,50).color(.red))([]),
                
                ])
        } else {
            return K(View(), props: ViewProps().frame(0,0,150,150).color(.purple))([
                K(Button(), props: ButtonsProps()
                    .frame(40,40,60,60)
                    .color(.orange)
                    .text("state 3")
                    .onTap({ update(0) })
                    )([]),
                ])
        }
    
    }
}

