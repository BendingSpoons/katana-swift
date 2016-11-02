//
//  NodeDescription.swift
//  Katana
//
//  Created by Luca Querella on 09/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

/**
 Protocol that is used for structs that represent the state of a `Node`.
 
 This protocol requires instances to be equatable. Katana uses this requirement to
 avoid to update the UI if the state (and the props) are not changed.
*/
public protocol NodeState: Equatable {
  /**
   Default init for the state. It is used by Katana to create the initial state of a `Node`.
   You should initialise the state with meaningful default values.
  */
  init()
}

public extension NodeState {
  /**
   Default implementation of the function required by `Equatable`. It always returns `false`.
   Developers can use this as the default implementation and then implement the proper equatable logic
   to optimise performances (e.g., avoid useless UI updates)
   
   - parameter l: the first state
   - parameter r: the second state
   - returns: always false
  */
  static func == (l: Self, r: Self) -> Bool {
    return false
  }
}

/**
 Protocol that is used for structs that represent the properties of a `NodeDescription`.
 
 This protocol requires instances to be equatable. Katana uses this requirement to
 avoid to update the UI if the properties (and the state) are not changed.
*/
public protocol NodeProps: Equatable, Frameable {}

public extension NodeProps {
  /**
   Default implementation of the function required by `Equatable`. It always returns `false`.
   Developers can use this as the default implementation and then implement the proper equatable logic
   to optimise performances (e.g., avoid useless UI updates)
   
   - parameter l: the first props
   - parameter r: the second props
   - returns: always false
   */
  static func == (l: Self, r: Self) -> Bool {
    return false
  }
}

/// Type Erasure for the `NodeDescription` protocol
public protocol AnyNodeDescription {

  /// frame of the description
  var frame: CGRect { get set }
  
  /** 
    key of the description
  */
  var key: String? { get }
  
  /// Type erasure for `props`
  var anyProps: Any { get }
  
  /**
    The replace key of the description. When two descriptions have the same replaceKey, Katana consider them interchangeable.
    During an UI update, Katana will try to minimise the creation of new nodes (and therefore UIView instances) by reusing old nodes.
    This is only possible when the old node description is interchangeable with the node that Katana is trying to render.
   
    You can customise the replace key to control the reuse of nodes and views.
  */
  var replaceKey: Int { get }
  
  /**
   Returns a node instance associated with the description.
   - parameter parent: the parent node to associate with the node
   - returns: the node instance
  */
  func makeNode(parent: AnyNode?) -> AnyNode
  
  /**
   Creates a root node (that is, the root of the UI hierarchy) with the given store
   
   - seeAlso: `Store`
   
   - parameter store: the store to use to manage the application's state
   - returns: the root instance
   */
  func makeRoot(store: AnyStore?) -> Root
}

/**
 A `NodeDescription` defines a specific piece of UI. You can think to a `NodeDescription` as a stencil that
 describes how a piece of UI should look like.
 
 `NodeDescription` methods are stateless. This is because the properties and the state are hold
  by a `Node` instance (see `Node` for more information) that Katana automatically creates.
 
 In general a description defines two things:
 
 - how properties and state are used to personalise the instance of UIView (or subclass) associated with the `Node` instance.
   This view is also named **NativeView**

 - what are the children descriptions given the properties and the state
 
 ### Node and NodeDescription relationship
 It is important to remember that the UI hierarchy have a 1:1 relationship with `Node` instances
 and not with `NodeDescription`. This means that each `UIView` in the UIKit UI tree is connected to a `Node` instance.
 This instance holds the description that is used to manage the `UIView` (and the children), properties and the state.
 
 This is why all the `NodeDescription` methods are static.
 Description instances are meaningless and are used only as an easy to ready way
 to describe the UI in the `childrenDescriptions` method.
 These instances are used by Katana to understand how update the UI (update, remove and add views) and then thrown away.
 
*/
public protocol NodeDescription: AnyNodeDescription {
  
  /// The UIKit class that will be instantiated for this description. The default value is `UIView`
  associatedtype NativeView: UIView = UIView
  
  /// The type of properties that this description uses. The default value is `EmptyProps`
  associatedtype PropsType: NodeProps = EmptyProps
  
  /// The type of state that this description uses. The default value is `EmptyState`
  associatedtype StateType: NodeState = EmptyState
  
  /// The properties of the the description
  var props: PropsType { get set }
  
  
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
                                     node: AnyNode) -> Void
  
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
                     dispatch: @escaping StoreDispatch) -> [AnyNodeDescription]
  
  
  /**
   This methdo is used to define what animation should be used to transition from the old UI state to the new one
   - parameter currentProps:    the props that have been used to create the current UI
   - parameter nextProps:       the props that will be used in the next UI update cycle
   - parameter currentState:    the state that has been used to create the current UI
   - parameter nextState:       the state that will be used in the next UI update cycle
   - parameter parentAnimation: the animation returned by the parent node
   - returns: the animation to apply to the children
   
   - note: it is important to note that the animation will be applied to the children. The native view will be updated using
           the animation returned by the parent
  */
  static func childrenAnimation(currentProps: PropsType,
                                nextProps: PropsType,
                                currentState: StateType,
                                nextState: StateType,
                                parentAnimation: Animation) -> Animation
  
}

extension NodeDescription {
  
  /// The default implementation just sets the frame of the native view to `props.frame`
  public static func applyPropsToNativeView(props: PropsType,
                                            state: StateType,
                                            view: NativeView,
                                            update: @escaping (StateType)->(),
                                            node: AnyNode) -> Void {
    view.frame = props.frame
  }
  
  /**
    The default implementation returns the parent animation. Katana has as default implementation `Animation.none`.
    This means that if this method is never implemented, then there are no animations in the application.
  */
  public static func childrenAnimation(currentProps: PropsType,
                                                    nextProps: PropsType,
                                                    currentState: StateType,
                                                    nextState: StateType,
                                                    parentAnimation: Animation) -> Animation {
    return parentAnimation
  }
}

extension AnyNodeDescription where Self: NodeDescription {
  /// Returns `props.frame`
  public var frame: CGRect {
    get {
      return self.props.frame
    }
    
    set(newFrame) {
      self.props.frame = newFrame
    }
  }
  
  /// `props.key` if props are `Keyable`, nil otherwise
  public var key: String? {
    guard let props = self.props as? Keyable else {
      return nil
    }
    
    return props.key
  }
  
  /// the node description properties
  public var anyProps: Any {
    return self.props
  }
  
  public func makeNode(parent: AnyNode?) -> AnyNode {
    return Node(description: self, parent: parent)
  }
  
  public func makeRoot(store: AnyStore?) -> Root {
    let root = Root(store: store)
    let node = Node(description: self, parent: nil, root: root)
    root.node = node
    return root
  }
  
  /**
   The default implementation of this method returns a value that allow Katana to exchange nodes related to the same description
   types. If the description has `Keyable` properties, the key is used as an extra source of information.
  */
  public var replaceKey: Int {
    if let props = self.props as? Keyable, let key = props.key {
      return "\(ObjectIdentifier(type(of: self)).hashValue)_\(key)".hashValue
    }
    
    return ObjectIdentifier(type(of: self)).hashValue
  }
}
