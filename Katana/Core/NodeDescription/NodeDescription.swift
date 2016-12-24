//
//  NodeDescription.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import CoreGraphics
/**
 Protocol that is used for structs that represent the state of a `Node`.
 
 This protocol requires instances to be equatable. Katana uses this requirement to
 avoid to update the UI if the state (and the props) are not changed.
*/
public protocol NodeDescriptionState: Equatable {
  /**
   Default init for the state. It is used by Katana to create the initial state of a `Node`.
   You should initialise the state with meaningful default values.
  */
  init()
}

public extension NodeDescriptionState {
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

/// Type Erasure for `NodeDescriptionProps`
public protocol AnyNodeDescriptionProps {
  /// The frame of the `NodeDescription`
  var frame: CGRect { get set }

  /// The alpha of the `NodeDescription`
  var alpha: CGFloat { get set }

  /**
   The key is used for many purposes. It is used for instance to calculate a more precise `replaceKey`,
   from Plastic to implement the layout system or in the animation management to reference children
  */
  var key: String? { get set }

  /**
   Helper method to translate any Swift value to a key, which is a String
   
   - parameter key: the key
  */
  mutating func setKey<K>(_ key: K)
}

public extension AnyNodeDescriptionProps {
  /// The default implementation uses the Swift string interpolation to create the key
  public mutating func setKey<Key>(_ key: Key) {
    self.key = "\(key)"
  }
}

/**
 Protocol that is used for structs that represent the properties of a `NodeDescription`.
 
 This protocol requires instances to be equatable. Katana uses this requirement to
 avoid to update the UI if the properties (and the state) are not changed.
*/
public protocol NodeDescriptionProps: AnyNodeDescriptionProps, Equatable {}

public extension NodeDescriptionProps {
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
  /// Type erasure for `props`
  var anyProps: AnyNodeDescriptionProps { get }

  /**
    The replace key of the description. When two descriptions have the same replaceKey, Katana consider them interchangeable.
    During an UI update, Katana will try to minimise the creation of new nodes
    (and therefore UIView/NSView instances) by reusing old nodes. This is only possible when the old node description
    is interchangeable with the node that Katana is trying to render.
   
    You can customise the replace key to control the reuse of nodes and views.
  */
  var replaceKey: Int { get }

  /**
   Initialise the description
   
   - parameter anyProps: the props to associated with the description instance
   - returns: a value of description with the given pros
  */
  init(anyProps: AnyNodeDescriptionProps)

  /**
   Returns a node instance associated with the description.
   - parameter parent: the parent node to associate with the node
   - returns: the node instance
  */
  func makeNode(parent: AnyNode) -> AnyNode

  /**
   Returns a node instance associated with a renderer.
   - parameter renderer: the renderer that is responsible to rendering the UI starting from this node description
   - returns: the node instance
   */
  func makeNode(renderer: Renderer) -> AnyNode
}

/// Default Keys used in `NodeDescription`
public enum EmptyKeys {}

/**
 A `NodeDescription` defines a specific piece of UI. You can think of a `NodeDescription` as a stencil that
 describes how a piece of UI should look like.
 
 `NodeDescription` methods are stateless. This is because the properties and the state are held
  by a `Node` instance (see `Node` for more information) that Katana automatically creates.
 
 In general, a description defines two things:
 
 - how properties and state are used to personalise the instance of UIView/NSView (or subclass)
 associated with the `Node` instance. This view is also named **NativeView**

 - what are the children descriptions given the properties and the state
 
 ### Node and NodeDescription relationship
 It is important to remember that the UI hierarchy has a 1:1 relationship with `Node` instances
 and not with `NodeDescription`. This means that each `UIView` in the UIKit UI tree
 (or `NSView` in the AppKit UI tree) is connected to a `Node` instance.
 This instance holds the description that is used to manage the `UIView` (or `NSView`) (and the children),
 properties and the state.
 
 This is why all the `NodeDescription` methods are static.
 Description instances are meaningless and are used only as an easy to ready way
 to describe the UI in the `childrenDescriptions(props:state:update:dispatch:)` method.
 These instances are used by Katana to understand how to update the UI (update, remove and add views) and then thrown away.
 
*/
public protocol NodeDescription: AnyNodeDescription {

  /// The PlatformNativeView class that will be instantiated for this description.
  associatedtype NativeView: PlatformNativeView = DefaultView

  /// The type of properties that this description uses. The default value is `EmptyProps`
  associatedtype PropsType: NodeDescriptionProps = EmptyProps

  /// The type of state that this description uses. The default value is `EmptyState`
  associatedtype StateType: NodeDescriptionState = EmptyState

  associatedtype Keys = EmptyKeys

  /// The properties of the the description
  var props: PropsType { get set }

  /**
   Creates a description with the given props
   
   - parameter props: the props to associate with the description
   - returns: a description with the given properties
  */
  init(props: PropsType)

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
                                     node: AnyNode)

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
   This method is used to describe the animations to perform.
   
   Based on the current state and props and the next ones, you should define the animations
   for the children.
   
   If the container is not updated, no animations will be performed
   
   - parameter container:       the container of the children animations
   - parameter currentProps:    the props that have been used to create the current UI
   - parameter nextProps:       the props that will be used in the next UI update cycle
   - parameter currentState:    the state that has been used to create the current UI
   - parameter nextState:       the state that will be used in the next UI update cycle
  */
  static func updateChildrenAnimations(container: inout ChildrenAnimations<Self.Keys>,
                                       currentProps: PropsType,
                                       nextProps: PropsType,
                                       currentState: StateType,
                                       nextState: StateType)

  /**
   This method is invoked just after the backing node is rendered in the view's hierarchy.
   Note that `childrenDescriptions` and `applyPropsToNativeView` will be invoked before this method
   
   - parameter props:     the initial props with which the description is created
   - parameter dispatch:  the store dispatch function. This closure is intentionally non escaping
  */
  static func didMount(props: PropsType, dispatch: StoreDispatch)

  /**
   This method is invoked just after the backing node is removed from the view's hierarchy.
   
   - parameter props:     the final props of the description
   - parameter dispastch: the store dispatch function. This closure is intentionally non escaping
   */
  static func didUnmount(props: PropsType, dispatch: StoreDispatch)

  /**
   This method is invoked when new props (that trigger a new update cycle) are received.
   You have the chance to update the internal state of the description without triggering a new render
   (new state will be immediately available in the next update cycle).
 
   - parameter state:           the current state of the description
   - parameter currentProps:    the current props of the description
   - parameter nextProps:       the just received props. They will be used as "props" in the next update cycle
   - parameter dispatch:        the store dispatch function. This closure is intentionally non escaping
   - parameter update:          the update function. It can be used to update the state without triggering new update cycles.
                                This closure is intentionally non escaping
  */
  static func descriptionWillReceiveProps(state: StateType,
                                          currentProps: PropsType,
                                          nextProps: PropsType,
                                          dispatch: StoreDispatch,
                                          update: (StateType) -> ())
}

public extension NodeDescription {

  /// The default implementation tries to force cast `anyProps` to the correct `PropsType`
  public init(anyProps: AnyNodeDescriptionProps) {
    let props = anyProps as! Self.PropsType
    self.init(props: props)
  }

  /// The default implementation just sets the frame of the native view to `props.frame`
  public static func applyPropsToNativeView(props: PropsType,
                                            state: StateType,
                                            view: NativeView,
                                            update: @escaping (StateType)->(),
                                            node: AnyNode) {
    view.frame = props.frame
    view.alpha = props.alpha
  }

  /// The default implementation does nothing. This is equivalent to never trigger an animation
  public static func updateChildrenAnimations(container: inout ChildrenAnimations<Self.Keys>,
                                       currentProps: PropsType,
                                       nextProps: PropsType,
                                       currentState: StateType,
                                       nextState: StateType) {
    // do nothing, which means no animations
  }

  /// The default implementation does nothing
  public static func didMount(props: PropsType, dispatch: StoreDispatch) {}

  /// The default implementation does nothing
  public static func didUnmount(props: PropsType, dispatch: StoreDispatch) {}

  /// The default implementation does nothing
  static func descriptionWillReceiveProps(state: StateType,
                                          currentProps: PropsType,
                                          nextProps: PropsType,
                                          dispatch: StoreDispatch,
                                          update: (StateType) -> ()) {}
}

extension AnyNodeDescription where Self: NodeDescription {
  /// the node description properties
  public var anyProps: AnyNodeDescriptionProps {
    return self.props
  }

  public func makeNode(parent: AnyNode) -> AnyNode {
    return Node(description: self, parent: parent)
  }

  public func makeNode(renderer: Renderer) -> AnyNode {
    return Node(description: self, renderer: renderer)
  }

  /**
   The default implementation of this method returns a value that allow Katana to exchange nodes related to the same description
   types. If the description has `Keyable` properties, the key is used as an extra source of information.
  */
  public var replaceKey: Int {
    if let key = self.anyProps.key {
      return "\(ObjectIdentifier(type(of: self)).hashValue)_\(key)".hashValue
    }

    return ObjectIdentifier(type(of: self)).hashValue
  }
}
