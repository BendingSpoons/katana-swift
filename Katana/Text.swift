//
//  View.swift
//  Katana
//
//  Created by Luca Querella on 10/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

public struct TextProps: Equatable,Colorable,Frameable,Textable,TouchDisableable  {
    public var frame = CGRect.zero
    public var color = UIColor.white
    public var touchDisabled =  true
    public var text: String = ""
    
    public static func ==(lhs: TextProps, rhs: TextProps) -> Bool {
        return lhs.frame == rhs.frame &&
            lhs.color == rhs.color &&
            lhs.touchDisabled == rhs.touchDisabled &&
            lhs.text == rhs.text
    }
    
    public init() {}
}


struct Text : NodeDescription {
    
    var props : TextProps
    var children: [AnyNodeDescription] = []
    
    static var initialState = EmptyState()
    static var viewType = UILabel.self
    
    static func renderView(props: TextProps, state: EmptyState, view: UILabel, update: (EmptyState)->())  {
        
        view.frame = props.frame
        view.backgroundColor = props.color
        view.isUserInteractionEnabled = !props.touchDisabled
        view.text = props.text
    }
    
    static func render(props: TextProps,
                       state: EmptyState,
                       children: [AnyNodeDescription],
                       update: (EmptyState)->()) -> [AnyNodeDescription] {
        return children
    }
    
    init(props: TextProps) {
        self.props = props
    }
    

    
    
}

