//
//  Button.swift
//  Katana
//
//  Created by Luca Querella on 10/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

public struct TouchHandlerProps: Equatable, Frameable  {
    
    public var frame = CGRect.zero
    var text = ""
    var touchHandler: ((Bool) -> ())?
    
    public static func ==(lhs: TouchHandlerProps, rhs: TouchHandlerProps) -> Bool {
        return false
    }
    
    func touchHandler(_ touchHandler: (Bool)->()) -> TouchHandlerProps {
        var copy = self
        copy.touchHandler = touchHandler
        return copy
    }
}

struct TouchHandler : NodeDescription {
    
    var props : TouchHandlerProps
    var children: [AnyNodeDescription] = []
    
    static var initialState = EmptyState()
    static var viewType = TouchHandlerView.self
    

    static func renderView(props: TouchHandlerProps, state: EmptyState, view: TouchHandlerView, update: (EmptyState)->())  {
        view.frame = props.frame
        view.handler = props.touchHandler
    }
    
    static func render(props: TouchHandlerProps,
                       state: EmptyState,
                       children: [AnyNodeDescription],
                       update: (EmptyState)->()) -> [AnyNodeDescription] {
        
        return children
    }
}


public class TouchHandlerView : UIControl {
    
    private var touching : Bool = false
    public var handler : ((Bool)->())?
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        if self.touching  {
            return false
        }
        
        self.touching = true
        self.handler?(self.touching)
        return true
    }
    
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        if (touching) {
            self.touching = false
            self.handler?(self.touching)
        }
    }
    
    public override func cancelTracking(with event: UIEvent?) {
        if (touching) {
            self.touching = false
            self.handler?(self.touching)
        }
    }
}
