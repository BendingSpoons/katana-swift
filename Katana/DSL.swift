//
//  DSL.swift
//  Katana
//
//  Created by Luca Querella on 04/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public func K<L:Logic>(_ logic: L, props: L.Props ) -> NodeDescription {
    return LogicNodeDescription<L>(props: props)
}

public func K<V:Visual>(_ visual: V, props: V.Props ) -> ([NodeDescription]) -> VisualNodeDescription<V> {
    func result(children: [NodeDescription]) -> VisualNodeDescription<V> {
        return VisualNodeDescription<V>(props: props, children: children)
    }
    
    return result
}
