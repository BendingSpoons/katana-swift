//
//  App.swift
//  Katana
//
//  Created by Luca Querella on 10/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit



struct App : NodeDescription {
    
    var props : EmptyProps
    var children: [AnyNodeDescription] = []
    
    static var initialState = false
    static var viewType = UIView.self
    

    
    static func render(props: EmptyProps,
                       state: Bool,
                       children: [AnyNodeDescription],
                       update: (Bool)->()) -> [AnyNodeDescription] {
        
        return [TouchHandler(props: TouchHandlerProps().frame(0, 0, 220, 220).touchHandler(update), children: [
            View(props: ViewProps().frame(0, 0, 100, 100).color(state ? .green : .red).disableTouch()),
            View(props: ViewProps().frame(0, 100, 100, 100).color(.red).disableTouch()),
            View(props: ViewProps().frame(100, 0, 100, 100).color(.purple).disableTouch()),
            View(props: ViewProps().frame(100, 100, 100, 100).color(.orange).disableTouch())
            
            ])]

    }

}
