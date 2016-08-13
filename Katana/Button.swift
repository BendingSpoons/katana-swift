//
//  Button.swift
//  Katana
//
//  Created by Luca Querella on 10/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit



public struct ButtonProps: Equatable, Colorable, Frameable, Textable, Tappable  {
    
    enum State {
        case normal
        case highlighted
    }
    
    public var frame = CGRect.zero
    var color = UIColor.white
    var highlightedColor = UIColor.white
    var onTap: (() -> ())?

    var text = ""
    
    public static func ==(lhs: ButtonProps, rhs: ButtonProps) -> Bool {
        return false
    }
    
    func color(_ color: UIColor, state: State) -> ButtonProps {
        var copy = self
        switch state {
        case .highlighted:
            copy.highlightedColor = color
            break
        default:
            copy.color = color
        }
        
        return copy
    }
    
}

struct Button : NodeDescription {
    
    var props : ButtonProps
    var children: [AnyNodeDescription] = []
    
    static var initialState = false
    static var viewType = UIView.self
    
    
    static func render(props: ButtonProps,
                       state: Bool,
                       children: [AnyNodeDescription],
                       update: (Bool)->()) -> [AnyNodeDescription] {
        
        func touchHandler(pressed: Bool) {
            if (pressed) {
                props.onTap?()
            }
            update(pressed)
        }
        
        return [TouchHandler(props: TouchHandlerProps().frame(props.frame.size).touchHandler(touchHandler), children: [
            View(props: ViewProps()
                    .frame(props.frame.size)
                    .color(state ? props.highlightedColor : props.color )
                    .disableTouch(), children : []),
            Text(props: TextProps()
                .frame(props.frame.size)
                .text(props.text)
                .color(.clear))
            ])]
        }
    
    init(props: ButtonProps) {
        self.props = props
    }
    
    
}
