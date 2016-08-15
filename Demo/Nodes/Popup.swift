//
//  Popup.swift
//  Katana
//
//  Created by Luca Querella on 13/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana

struct Popup : NodeDescription {
    
    var props : EmptyProps
    var children: [AnyNodeDescription] = []
    
    static var initialState = EmptyState()
    static var viewType = UIView.self
    
    
    
    static func render(props: EmptyProps,
                       state: EmptyState,
                       children: [AnyNodeDescription],
                       update: (EmptyState)->()) -> [AnyNodeDescription] {
        
        return [
            
            View(props: ViewProps()
                .frame(props.frame.size)
                .color(UIColor(white: 0, alpha: 0.8))),
            
            View(props: ViewProps()
                .frame(CGRect(x: 25, y: 40, width: 270, height: 400))
                .color(.white)
                .cornerRadius(10), children:children )
        ]
        
    }
    
}
