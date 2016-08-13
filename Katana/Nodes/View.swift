//
//  View.swift
//  Katana
//
//  Created by Luca Querella on 10/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

public struct ViewProps: Equatable, Colorable,Frameable, TouchDisableable  {
    public var frame = CGRect.zero
    public var color = UIColor.white
    public var touchDisabled =  false

    public static func ==(lhs: ViewProps, rhs: ViewProps) -> Bool {
        return lhs.frame == rhs.frame &&
            lhs.color == rhs.color &&
            lhs.touchDisabled == rhs.touchDisabled
    }
    
    public init() {}
}


public struct View : NodeDescription {
    
    public var props : ViewProps
    public var children: [AnyNodeDescription] = []
    
    public static var initialState = EmptyState()
    public static var viewType = UIView.self
    
    public static func renderView(props: ViewProps, state: EmptyState, view: UIView, update: (EmptyState)->())  {
        
        view.frame = props.frame
        view.backgroundColor = props.color
        view.isUserInteractionEnabled = !props.touchDisabled
    }
    
    public static func render(props: ViewProps,
                       state: EmptyState,
                       children: [AnyNodeDescription],
                       update: (EmptyState)->()) -> [AnyNodeDescription] {
        return children
    }
    
    public init(props: ViewProps) {
        self.props = props
    }
    
    public init(props: ViewProps, children: [AnyNodeDescription]) {
        self.props = props
        self.children = children
    }
    
    
}

