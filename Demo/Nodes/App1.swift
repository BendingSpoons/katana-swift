//
//  App.swift
//  Katana
//
//  Created by Luca Querella on 10/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana


struct App1 : NodeDescription {
    
    var props : EmptyProps
    var children: [AnyNodeDescription] = []
    
    static var initialState = 0
    static var viewType = UIView.self

    
    static func render(props: EmptyProps,
                       state: Int,
                       children: [AnyNodeDescription],
                       update: (Int)->()) -> [AnyNodeDescription] {
        
        if (state == 0) {
            
            return [View(props: ViewProps().frame(0,0,150,150).color(.gray), children: [
                Button(props: ButtonProps().frame(50,50,100,100)
                    .color(.orange, state: .normal)
                    .color(.orange, state: .highlighted)
                    .text("state 0")
                    .onTap({ update(1) }))
                ])]
            
        } else if (state == 1) {
            
            return [View(props: ViewProps().frame(0,0,150,160).color(.blue), children: [
                View(props: ViewProps().frame(0,0,70,70).color(.red)),
                Button(props: ButtonProps().frame(50,50,100,100)
                    .color(.orange, state: .normal)
                    .color(.orange, state: .highlighted)
                    .text("state 1")
                    .onTap({ update(2) }))
                ])]
            
        } else if (state == 2) {
            
            return [View(props: ViewProps().frame(0,0,150,170).color(.green), children: [
                Button(props: ButtonProps().frame(50,50,100,100)
                    .color(.orange, state: .normal)
                    .color(.orange, state: .highlighted)
                    .text("state 2")
                    .onTap({ update(3) })),
                View(props: ViewProps().frame(0,0,70,70).color(.red))

                ])]

            
        } else {
            
            return [View(props: ViewProps().frame(0,0,150,180).color(.red), children: [
                Button(props: ButtonProps().frame(40,40,60,60)
                    .color(.orange, state: .normal)
                    .color(.orange, state: .highlighted)
                    .text("state 3")
                    .onTap({ update(0) })),
                ])]
            
        }
    }
}
