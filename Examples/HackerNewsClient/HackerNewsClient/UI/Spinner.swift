//
//  Spinner.swift
//  HackerNewsClient
//
//  Created by Francesco Di Lorenzo on 15/11/2016.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Katana
import KatanaElements

struct Spinner: NodeDescription {
    typealias PropsType = Props
    typealias StateType = EmptyState
    typealias NativeView = UIActivityIndicatorView
    typealias Keys = EmptyKeys
    
    var props: PropsType
    
    static func childrenDescriptions(props: PropsType,
                                     state: StateType,
                                     update: @escaping (StateType) -> (),
                                     dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
        
        return []
    }
    
    static func applyPropsToNativeView(props: PropsType,
                                       state: StateType,
                                       view: NativeView,
                                       update: @escaping (StateType)->(),
                                       node: AnyNode) {
        view.frame = props.frame
        
        if props.spinning {
            view.startAnimating()
        } else {
            view.stopAnimating()
        }
    }
}

extension Spinner {
    struct Props: NodeDescriptionProps, Buildable {
        var frame: CGRect = .zero
        var key: String?
        var alpha: CGFloat = 1.0
        
        var spinning = false
    }
}
