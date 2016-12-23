//
//  Node.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

// swiftlint:disable file_length

/// typealias for the dictionary used to store the nodes during the update phase
private typealias ChildrenDictionary = [Int:[(node: AnyNode, index: Int)]]

/**
  Katana works by representing the UI as a tree.
 Beside the tree managed by UIKit/AppKit with UIView/NSView (or subclasses) instances through PlatformNativeViews,
  Katana holds a tree of instances of `Node`. The tree is composed as follows:
 
  - each node of the tree is an instance of PlatformNativeView (baked by UIKit/AppKit or subclasses);
 
  - the edges between nodes represent the parent/children (or view/subviews) relation.
 
  Each `Node` instance is characterized by a description (which is an implementation of `NodeDescription`).
  Since descriptions are stateless, the `Node` also holds properties and state. It is also in charge of managing the lifecycle
  of the UI and in particular to invoke the methods `childrenDescriptions` and
  `applyPropsToNativeView` of `NodeDescription` when needed.
 
  In general this class is never used during the development of an application. Developers usually work with `NodeDescription`.
 
  ## Managed Children
  Most of the time, `Node` is able to generate and handle its children automatically by using the description methods.

  That being said, there are cases where this is not possible
  (e.g., in a table, when you need to generate and handle the nodes contained in the cells).
  In order to maintain an unique tree to represent the UI, we ask to handle these
  cases manually by invoking two methods: `addManagedChild(with:in:)` and `removeManagedChild(node:)`.
  
  Having a single tree is important for several reasons.
  For example we may want to run automatic tests on the tree and verify some conditions (e.g., there is a button).

  Managed children are added to act as a workaround of a current limitation of Katana.
  We definitively want to remove this limitation and automate the management of the children in all the cases.
*/
public class Node<Description: NodeDescription> {
  
  /// The children of the node
  public fileprivate(set) var children: [AnyNode]!
  
  /// The current state of the node
  public fileprivate(set) var state: Description.StateType
  
  /// The container in which the node will be drawn
  public var container: PlatformNativeView?
  
  /// The children descriptions of the node
  fileprivate var childrenDescriptions: [AnyNodeDescription]!
  
  /// The current description of the node
  fileprivate(set) var description: Description
  
  /// An ID that represent the animation that is currently running
  fileprivate var animationID: Int?
  
  /**
    The parent of the node.
  */
  public fileprivate(set) weak var parent: AnyNode?
  
  /**
   The renderer of the node. This is a private variable where we store the reference to the Renderer object.
   Please note that this will contain the Renderer only for the first Node of the hierarchy, for the others it will be nil.
   To retrieve the Renderer from every Node just use the renderer computed variable that
   will traverse the nodes tree up to the root node and returns root.myRenderer
   */
  fileprivate weak var myRenderer: Renderer?
  
  
  
  /// The array of managed children of the node
  public var managedChildren: [AnyNode] = []

  /**
   Creates an instance of node.
  
   - parameter description: The description to associate with the node
   - parameter parent:      The parent of the node
   - returns: an instance of `Node` with the given parameters
  */
  public convenience init(description: Description, parent: AnyNode) {
    self.init(description: description, parent: parent, renderer: nil)
  }
 
  /**
   Creates an instance of node
   
   - parameter description: The description to associate with the node
   - parameter renderer:    The renderer of the node. The node will be managed by the renderer as a root node
   - returns: an instance of `Node` with the given parameters
   
   - note: the `parent` parameter will be nil
  */
  public convenience init(description: Description, renderer: Renderer) {
    self.init(description: description, parent: nil, renderer: renderer)
  }

  /**
   Creates an instance of node given a description and the renderer
   
   - note: You can either pass `parent` or `renderer` but not both. Internally `renderer`
           is passed when a renderer is created starting from this node description
   
   - parameter description: The description to associate with the node
   - parameter parent:      The parent of the node
   - parameter renderer:         The renderer of the node. The node will be managed by the renderer as a root node
   
   - returns: A valid instance of Node
  */
  internal init(description: Description, parent: AnyNode?, renderer: Renderer?) {
    guard (parent != nil) != (renderer != nil) else {
      fatalError("either the parent or the renderer should be passed")
    }
    
    self.description = description
    self.state = Description.StateType.init()
    self.parent = parent
    self.myRenderer = renderer
    
    self.description.props = self.updatedPropsWithConnect(description: description, props: self.description.props)
    
    self.childrenDescriptions  = self.processedChildrenDescriptionsBeforeDraw(
      self.getChildrenDescriptions()
    )
        
    self.children = self.childrenDescriptions.map {
      $0.makeNode(parent: self)
    }
  }
  
  /**
   This method is invoked during the update of the UI, after the invocation of `childrenDescriptions` of the description
   associated with the node and before the process of updating the UI begins.
   
   This method is basically a customization point for subclasses to process and edit the children
   descriptions before they are actually used.
   
   - parameter children: The children to process
   - returns: the processed children
   */
  public func processedChildrenDescriptionsBeforeDraw(_ children: [AnyNodeDescription]) -> [AnyNodeDescription] {
    // NOTE: this method is here because Swift doesn't support override of extension methods yet
    return children
  }
  
  deinit {
    let dispatch =  self.renderer?.store?.dispatch ?? { fatalError("\($0) cannot be dispatched. Store not avaiable.") }
    Description.didUnmount(props: self.description.props, dispatch: dispatch)
  }
}


// MARK: Render
extension Node {
  /**
   Renders the node in a given container. Draws a node basically means create
   the necessary UIKit classes (most likely UIView/NSView or subclasses) and add them to the UI hierarchy.
   
   -note:
   This method should be invoked only once, the first time a node is drawn. For further updates of the UI managed by
   the node, see `redraw`
   
   - parameter container: the container in which the node should be drawn
   */
  func render(in container: PlatformNativeView) {
    if self.container != nil {
      fatalError("draw can only be call once on a node")
    }
    
    self.container = container.addChild() { Description.NativeView.make() }
    
    let update = { [weak self] (state: Description.StateType) in
      DispatchQueue.main.async {
        self?.update(for: state)
      }
    }
    
    self.container?.update { view in
      Description.applyPropsToNativeView(props: self.description.props,
                                         state: self.state,
                                         view: view as! Description.NativeView,
                                         update: update,
                                         node: self)
    }
    
    
    let dispatch =  self.renderer?.store?.dispatch ?? { fatalError("\($0) cannot be dispatched. Store not avaiable.") }
    Description.didMount(props: self.description.props, dispatch: dispatch)
    
    children.forEach { child in
      let child = child as! InternalAnyNode
      child.render(in: self.container!)
    }
  }
  
  /**
   ReRender a node.
   
   After the invocation of `draw`, it may be necessary to update the UI (e.g., because props or state are changed).
   This method takes care of updating the the UI based on the new description
   
   - parameter childrenToAdd: an array of children that weren't in the UI hierarchy before and that have to be added
   - parameter viewIndexes:   an array of replaceKey that should be in the UI hierarchy after the update.
   The method will use this array to remove nodes if necessary
   
   - parameter animation:     the animation to use to transition from the previous UI to the new one
   
   - parameter callback:               a callback that is invoked when the method has eneded its job
   - parameter childrenRenderCallback: a callback that is invoked every time a children is managed
   (e.g., added to the UI hierarchy)
   */
  fileprivate func reRender(childrenToAdd: [AnyNode],
                            viewIndexes: [Int],
                            animation: AnimationContainer,
                            callback: (() -> ())?,
                            childrenRenderCallback: (() -> ())?) {
    
    guard let container = self.container else {
      return
    }
    
    assert(viewIndexes.count == self.children.count)
    
    var nativeViewUpdateDone = false
    var reRenderDone = false
    
    let update = { [weak self] (state: Description.StateType) -> () in
      self?.update(for: state)
    }
    
    let updateBlock = { () -> () in
      container.update { view in
        Description.applyPropsToNativeView(props: self.description.props,
                                           state: self.state,
                                           view: view as! Description.NativeView,
                                           update: update,
                                           node: self)
      }
    }

    
    Description.NativeView.animate(type: animation.nativeViewAnimation, updateBlock, completion: {
      nativeViewUpdateDone = true
      
      if reRenderDone {
        callback?()
      }
    })
    
    
    childrenToAdd.forEach { node in
      let node = node as! InternalAnyNode
      node.render(in: container)
      childrenRenderCallback?()
    }
    
    var currentSubviews: [PlatformNativeView?] =  container.children()
    let sorted = viewIndexes.isSorted
    
    for viewIndex in viewIndexes {
      let currentSubview = currentSubviews[viewIndex]!
      if !sorted {
        container.bringChildToFront(currentSubview)
      }
      currentSubviews[viewIndex] = nil
    }
    
    for view in currentSubviews {
      if let viewToRemove = view {
        self.container?.removeChild(viewToRemove)
      }
    }
    
    reRenderDone = true
    if nativeViewUpdateDone {
      callback?()
    }
  }
}


// MARK: Managed children
extension Node {
  /**
   Add a managed child to the node
   
   - parameter description: the description that will characterize the node that will be added
   - parameter container:   the container in which the new node will be drawn
   
   - returns: the node that has been created. The node will have the current node as parent
   */
  public func addManagedChild(with description: AnyNodeDescription, in container: PlatformNativeView) -> AnyNode {
    let node = description.makeNode(parent: self) as! InternalAnyNode
    self.managedChildren.append(node)
    node.render(in: container)
    return node
  }
  
  /**
   Removes a managed child from the node. For more information about managed children see the `Node` class
   
   - parameter node: the node to remove
   */
  public func removeManagedChild(node: AnyNode) {
    let index = self.managedChildren.index { node === $0 }
    self.managedChildren.remove(at: index!)
  }
}

// MARK: Children management
extension Node {
  /**
   This method returns the children descriptions based on the current description, the current props and the current state.
   It basically invokes `childrenDescription` of `NodeDescription`
   
   - returns: the array of children descriptions of the node
   */
  fileprivate func getChildrenDescriptions() -> [AnyNodeDescription] {
    let update = { [weak self] (state: Description.StateType) -> () in
      DispatchQueue.main.async {
        self?.update(for: state)
      }
    }
    
    let dispatch =  self.renderer?.store?.dispatch ?? { fatalError("\($0) cannot be dispatched. Store not avaiable.") }
    
    return type(of: description).childrenDescriptions(props: self.description.props,
                                                      state: self.state,
                                                      update: update,
                                                      dispatch: dispatch)
  }
  
  /**
   This method updates the properties using information from the Store's state.
   
   - note: This method does nothing if the current description does not conform to `ConnectedNodeDescription`
   - seeAlso: `ConnectedNodeDescription`
   
   - parameter description: the `NodeDescription` to use to update the properties
   - parameter props:       the properties to update
   
   - returns: the updated properties
   */
  func updatedPropsWithConnect(description: Description, props: Description.PropsType) -> Description.PropsType {
    if let desc = description as? AnyConnectedNodeDescription {
      // description is connected to the store, we need to update it
      
      guard let store = self.renderer?.store else {
        fatalError("connected node lacks store")
      }
      
      let state = store.anyState
      return type(of: desc).anyConnect(parentProps: description.props, storeState: state) as! Description.PropsType
    }
    
    return props
  }
}


// MARK: Update
extension Node {
  /**
    Updates the node with a new state. Invoking this method will cause an update of the piece of the UI managed by the node
   
    - parameter state: the new state
  */
  func update(for state: Description.StateType) {
    self.update(for: state, description: self.description, animation: .none)
  }

  /**
   Updates the node with a new state and description.
   Invoking this method will cause an update of the piece of the UI managed by the node
   
   - parameter state:           the new state to use
   - parameter description:     the new description to use
   - parameter animation:       the animation to use for the update
   - parameter force:           true if the update should be forced.
                                Force an update means that state and props equality are ignored
                                and basically the UI is always refreshed
   
   - parameter completion:      a block that is invoked when the update is completed
   */
  func update(for state: Description.StateType,
              description: Description,
              animation: AnimationContainer,
              force: Bool = false,
              completion: NodeUpdateCompletion? = nil) {

    guard force || self.description.props != description.props || self.state != state else {
      completion?()
      return
    }
    
    // update the internal state
    let currentState = self.state
    let currentDescription = self.description
    self.description = description
    self.state = state
    
    // calculate new children
    let newChildrenDescriptions = self.processedChildrenDescriptionsBeforeDraw(
      self.getChildrenDescriptions()
    )
    
    if animation.childrenAnimation.shouldAnimate {
      // We have received an animation from the parent (or whoever invoked the update).
      // Just invoke an update with the given animation
      self.update(newChildrenDescriptions: newChildrenDescriptions, animation: animation, completion: completion)
      return
    }
    
    
    // The update hasn't an animation
    // Give a chance to the description to return an animation for the next update cycle
    var childrenAnimations = ChildrenAnimations<Description.Keys>()
    
    Description.updateChildrenAnimations(
      container: &childrenAnimations,
      currentProps: currentDescription.props,
      nextProps: self.description.props,
      currentState: currentState,
      nextState: self.state
    )
    
    let animationToPerform = AnimationContainer(
      nativeViewAnimation: animation.nativeViewAnimation,
      childrenAnimation: childrenAnimations
    )
    
    
    // if we have an animation for the children, we need to perform it. Otherwise it is just
    // a normal update
    if animationToPerform.childrenAnimation.shouldAnimate {
      self.animatedChildrenUpdate(
        from: self.childrenDescriptions,
        to: newChildrenDescriptions,
        animation: animationToPerform,
        completion: completion
      )
    
    } else {
      self.update(newChildrenDescriptions: newChildrenDescriptions, animation: animationToPerform, completion: completion)
    }
  }
  
  /**
   Trigger an animated update of the children.
   In this method we need to perform a 4 step animation to manage children that are created and
   destroyed in the process
   
   - parameter initialChildren: the children of the initial (that is, the current) state
   - parameter finalChildren:   the children of the node after the animation process
   - parameter animation:       the animation to use
   - parameter completion:      a completion block to invoke at the end of the update
  */
  fileprivate func animatedChildrenUpdate(from initialChildren: [AnyNodeDescription],
                                          to finalChildren: [AnyNodeDescription],
                                          animation: AnimationContainer,
                                          completion: NodeUpdateCompletion?) {
    
    // first transition state
    var firstTransitionChildren = AnimationUtils.mergedDescriptions(initialChildren, finalChildren, step: .firstIntermediate)
    
    firstTransitionChildren = AnimationUtils.updatedDescriptions(
      for: firstTransitionChildren,
      using: animation.childrenAnimation,
      targetChildren: initialChildren,
      step: .firstIntermediate
    )

    // second transition state
    var secondTransitionChildren = AnimationUtils.mergedDescriptions(initialChildren, finalChildren, step: .secondIntermediate)
    
    secondTransitionChildren = AnimationUtils.updatedDescriptions(
      for: secondTransitionChildren,
      using: animation.childrenAnimation,
      targetChildren: finalChildren,
      step: .secondIntermediate
    )

    // assign an hash to the animation, we use will it later to check the animation completion step
    let randomID = Int.random
    self.animationID = randomID
    
    // perform the steps
    self.update(newChildrenDescriptions: firstTransitionChildren, animation: .none) { [weak self] in
      self?.update(newChildrenDescriptions: secondTransitionChildren, animation: animation) { [weak self] in
        
        // we need to check the animation hash. If it is the same it means the animation has not been interrupted.
        // If an animation is interrupted, we don't need to execute the last step for that specific animation
        if let id = self?.animationID, id == randomID {
          // final state
          self?.update(newChildrenDescriptions: finalChildren, animation: .none, completion: completion)
          
        } else {
          completion?()
        }
        
        self?.animationID = nil
      }
    }
  }
  
  /**
   Perform an update of the node. This method is different from `animatedChildrenUpdate` since
   it won't manage creation and deletion of children gracefully
   
   - parameter newChildrenDescription:  the children to render
   - parameter animation:               the animation to use
   - parameter completion:              a completion block invoked at the end of the update
  */
  fileprivate func update(newChildrenDescriptions: [AnyNodeDescription],
                          animation: AnimationContainer,
                          completion: NodeUpdateCompletion?) {

    var nodes: [AnyNode] = []
    var viewIndexes: [Int] = []
    var childrenToAdd: [AnyNode] = []
    
    // manage completion block
    // if we don't have it, just don't do anything. But if we have it, we need to
    // wait until all the node.update, native view update and add of new nodes
    // are completed and also the update of the native view
    var nativeViewUpdateCompleted = false
    var childUpdateCompletedCounter = 0
    var nativeViewCallback: (() -> ())?
    var childrenCallback: (() -> ())?
    
    if completion != nil {
      nativeViewCallback = { () -> () in
        nativeViewUpdateCompleted = true

        if childUpdateCompletedCounter == newChildrenDescriptions.count {
          completion?()
        }
      }
      
      childrenCallback = { () -> () in
        childUpdateCompletedCounter = childUpdateCompletedCounter + 1
        
        if nativeViewUpdateCompleted && childUpdateCompletedCounter == newChildrenDescriptions.count {
          completion?()
        }
      }
    }
    
    var currentChildren = ChildrenDictionary()
    
    for (index, child) in self.children.enumerated() {
      let key = child.anyDescription.replaceKey
      let value = (node: child, index: index)
      
      if currentChildren[key] == nil {
        currentChildren[key] = [value]
      } else {
        currentChildren[key]!.append(value)
      }
    }
    
    for newChildDescription in newChildrenDescriptions {
      let key = newChildDescription.replaceKey
      
      let childrenCount = currentChildren[key]?.count ?? 0
      
      if childrenCount > 0 {
        let replacement = currentChildren[key]!.removeFirst()
        assert(replacement.node.anyDescription.replaceKey == newChildDescription.replaceKey)
        
        // create the animation for the child. We propagate the children animation
        let childAnimation = animation.animation(for: newChildDescription)
        replacement.node.update(with: newChildDescription, animation: childAnimation, completion: childrenCallback)
        
        nodes.append(replacement.node)
        viewIndexes.append(replacement.index)
        
      } else {
        //else create a new node
        let node = newChildDescription.makeNode(parent: self)
        viewIndexes.append(children.count + childrenToAdd.count)
        nodes.append(node)
        childrenToAdd.append(node)
      }
    }
    
    self.childrenDescriptions = newChildrenDescriptions
    self.children = nodes
    
    self.reRender(
      childrenToAdd: childrenToAdd,
      viewIndexes: viewIndexes,
      animation: animation,
      callback:  nativeViewCallback,
      childrenRenderCallback: childrenCallback
    )
  }
}

extension Node : InternalAnyNode {}

// MARK: Renderer Connection
extension Node {
  /**
   The renderer of the node. This is a computed variable that traverses the tree up to the root node and returns root.renderer
   */
  public var renderer: Renderer? {
    guard self.myRenderer == nil else { return self.myRenderer! }
    return self.parent?.renderer
  }
}
