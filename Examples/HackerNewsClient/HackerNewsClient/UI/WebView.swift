//
//  WebView.swift
//  HackerNewsClient
//
//  Created by Francesco Di Lorenzo on 15/11/2016.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import WebKit
import Katana
import KatanaElements

struct WebView: NodeDescription {
    typealias PropsType = Props
    typealias StateType = EmptyState
    typealias NativeView = WKWebView
    typealias Keys = ChildrenKeys
    
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
        
        if let url = props.url {
            view.load(URLRequest(url: url))
        }
    }
}

extension WebView {
    enum ChildrenKeys {
    }
}

extension WebView {
    struct Props: NodeDescriptionProps, Buildable {
        var frame: CGRect = .zero
        var key: String?
        var alpha: CGFloat = 1.0
        var url: URL?
    }
}
