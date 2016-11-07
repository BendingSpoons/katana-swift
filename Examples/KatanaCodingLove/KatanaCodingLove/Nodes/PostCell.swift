//
//  PostCell.swift
//  Katana
//
//  Created by Alain Caltieri on 07/11/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import Katana
import KatanaElements




extension PostCell {
    enum Keys: String {
        case tableView
        case titleLabel
        case headerView
    }
    
    struct Props: NodeProps {
        var frame: CGRect = .zero
        //    var posts: [Post] = []
        //    var loading: Bool = true
        //    var allPostsFetched: Bool = false
    }
}

struct PostCell: NodeDescription {
    typealias StateType = EmptyState
    typealias PropsType = Props
    typealias NativeView = UIView
    
    var props: Props
    
    /**
     This method is used to update the `NativeView` starting from the given properties and state
     - parameter props:  the properties
     - parameter state:  the state
     - parameter view:   the instance of the native view
     - parameter update: a function that can be used to update the state
     - parameter node:   the instance of the `Node` that holds the `view` instance
     
     - warning: `update` cannot be invoked synchronously.
     */
    static func applyPropsToNativeView(props: PropsType,
                                       state: StateType,
                                       view: NativeView,
                                       update: @escaping (StateType)->(),
                                       node: AnyNode) -> Void {
    }
    
    /**
     This method is used to describe the children starting from the given properties and state
     - parameter props:    the properties
     - parameter state:    the state
     - parameter update:   a function that can be used to update the state
     - parameter dispatch: a function that can be used to dispatch actions
     
     - returns: the array of children descriptions
     
     - seeAlso: `Store`
     */
    static func childrenDescriptions(props: PropsType,
                                     state: StateType,
                                     update: @escaping (StateType)->(),
                                     dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
        return [

        ]
    }
    
    
    static func childrenAnimation(currentProps: PropsType,
                                  nextProps: PropsType,
                                  currentState: StateType,
                                  nextState: StateType,
                                  parentAnimation: Animation) -> Animation {
        return parentAnimation
    }
    
    
    static func layout(views: ViewsContainer<Keys>, props: Props, state: EmptyState) {
        //        let rootView = views.nativeView
        //        let title = views[.title]!
        //        let todoList = views[.todoList]!
        //
        //        title.asHeader(rootView, insets: .scalable(30, 0, 0, 0))
        //        title.height = .scalable(60)
        //
        //        todoList.fillHorizontally(rootView)
        //        todoList.top = title.bottom
        //        todoList.bottom = rootView.bottom
    }
    
}
