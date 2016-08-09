//
//  NodeDescription.swift
//  Katana
//
//  Created by Luca Querella on 02/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import UIKit

public protocol Logic {
    associatedtype Props: Equatable
    associatedtype State: Equatable
    static func logic(state: State, props: Props, update: (State)->())-> (NodeDescription)
    static var initialState: State {get}
}

public protocol Visual {
    associatedtype View: UIKit.UIView
    associatedtype Props: Equatable
    static func applyProps(props: Props, view: View) -> ()
}

public struct LogicNodeDescription<L:Logic> : NodeDescription {
    let props: L.Props
    
    public func node() -> Node {
        return LogicNode(description: self)
    }
    
    public func replaceKey() -> Int {
        return ObjectIdentifier(LogicNodeDescription<L>.self).hashValue
    }

}

public struct VisualNodeDescription<V:Visual> : NodeDescription {
    let props: V.Props
    let children: [NodeDescription]
    
    public func node() -> Node {
        return VisualNode(description: self)
    }
    
    public func replaceKey() -> Int {
        return ObjectIdentifier(VisualNodeDescription<V>.self).hashValue
    }
}

public protocol NodeDescription {
    func node() -> Node
    func replaceKey() -> Int
}



