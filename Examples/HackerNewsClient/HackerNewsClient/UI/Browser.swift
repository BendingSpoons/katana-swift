//
//  Browser.swift
//  HackerNewsClient
//
//  Created by Francesco Di Lorenzo on 15/11/2016.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation
import Katana
import KatanaElements

struct Browser: NodeDescription, PlasticNodeDescription {
    typealias PropsType = Props
    typealias StateType = EmptyState
    typealias NativeView = UIView
    typealias Keys = ChildrenKeys
    
    var props: PropsType
    
    static func childrenDescriptions(props: PropsType,
                                     state: StateType,
                                     update: @escaping (StateType) -> (),
                                     dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
        func goBack() {
            dispatch(GoBack())
        }
        
        return [
            View(props: View.Props.build({
                $0.setKey(ChildrenKeys.topBar)
                $0.backgroundColor = UIColor(red:0.95, green:0.36, blue:0.13, alpha:1.00)
            })),
            Button(props: Button.Props.build({
                $0.setKey(ChildrenKeys.closeButton)
                $0.titles = [ .normal: "Close" ]
                $0.titleColors = [
                    .normal: UIColor.white,
                    .highlighted: UIColor(white: 1.0, alpha: 0.5)
                ]
                $0.backgroundColor = .clear
                $0.touchHandlers = [
                    .touchUpInside: goBack
                ]
            })),
            WebView(props: WebView.Props.build({
                $0.setKey(ChildrenKeys.webView)
                $0.url = props.url
            })),
        ]
    }
    
    static func layout(views: ViewsContainer<Keys>,
                       props: PropsType,
                       state: StateType) {
        let root = views.nativeView
        let topBar = views[.topBar]!
        let closeButton = views[.closeButton]!
        let webView = views[.webView]!
        
        topBar.height = .scalable(80)
        topBar.asHeader(root, insets: .scalable(30, 0, 0, 0))
        
        closeButton.fillVertically(topBar)
        closeButton.width = .scalable(100)
        closeButton.setLeft(topBar.left, offset: .scalable(10))
        
        webView.fillHorizontally(root)
        webView.top = topBar.bottom
        webView.bottom = root.bottom
    }
}

extension Browser {
    enum ChildrenKeys {
        case topBar
        case closeButton
        case webView
    }
}

extension Browser {
    struct Props: NodeDescriptionProps, Buildable {
        var frame: CGRect = .zero
        var key: String?
        var alpha: CGFloat = 1.0
        
        var url: URL?
    }
}
