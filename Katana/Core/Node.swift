//
//  Node.swift
//  Katana
//
//  Created by Luca Querella on 09/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

public protocol AnyNode: class, PlasticMultiplierProvider {
  var description : AnyNodeDescription { get }
  var children : [AnyNode]? { get }
  var store: AnyStore { get }

  func draw(container: DrawableContainer)
  func update(description: AnyNodeDescription) throws
}

public class Node<Description: NodeDescription>: ConnectedNode, AnyNode {
  public private(set) var children : [AnyNode]?
  public private(set) unowned var store: AnyStore
  
  var state : Description.State
  var typedDescription : Description
  weak var parentNode: AnyNode?
  
  private var container: DrawableContainer?  
  
  public var description: AnyNodeDescription {
    get {
      return self.typedDescription
    }
  }
  
  public init(description: Description, parentNode: AnyNode?, store: AnyStore) {
    self.typedDescription = description
    self.state = Description.initialState
    self.parentNode = parentNode
    self.store = store
    
    let update = { [weak self] (state: Description.State) -> Void in
      self?.update(state: state)
    }
    
    self.typedDescription.props = self.updatedPropsWithConnect(description: description, props: self.typedDescription.props)

    let children  = Description.render(props: self.typedDescription.props,
                                       state: self.state,
                                       update: update,
                                       dispatch: self.store.dispatch)
    
    self.children =  self.processChildrenBeforeDraw(children).map {
      $0.node(parentNode: self)
    }
  }
  
  func updatedPropsWithConnect(description: Description, props: Description.Props) -> Description.Props {
    if let desc = description as? AnyConnectedNodeDescription {
      // description is connected to the store, we need to update it
      let state = self.store.getAnyState()
      return desc.dynamicType.anyConnect(parentProps: description.props, storageState: state) as! Description.Props
    }
    
    return props
  }
  
  func update(state: Description.State)  {
    self.update(state: state, description: self.typedDescription)
  }
  
  public func update(description: AnyNodeDescription) throws {
    var description = description as! Description
    description.props = self.updatedPropsWithConnect(description: description, props: description.props)
    self.update(state: self.state, description: description)
  }
  
  func update(state: Description.State, description: Description) {
    guard let children = self.children else {
      fatalError("update should not be called at this time")
    }
    
    let sameProps = self.typedDescription.props == description.props
    let sameState = self.state == state
    
    if (sameProps && sameState) {
      return
    }
    
    self.typedDescription = description
    self.state = state
    
    var currentChildren : [Int:[(node: AnyNode, index: Int)]] = [:]
    
    for (index,child) in children.enumerated() {
      let key = child.description.replaceKey()
      let value = (node: child, index: index)
      
      if currentChildren[key] == nil {
        currentChildren[key] = [value]
      } else {
        currentChildren[key]!.append(value)
      }
    }


    let update = { [weak self] (state: Description.State) -> Void in
      self?.update(state: state)
    }
    
    var newChildren = Description.render(props: self.typedDescription.props,
                                         state: self.state,
                                         update: update,
                                         dispatch: self.store.dispatch)
    
    newChildren = self.processChildrenBeforeDraw(newChildren)
    
    var nodes : [AnyNode] = []
    var viewIndex : [Int] = []
    var nodesToRender : [AnyNode] = []
    
    for newChild in newChildren {
      let key = newChild.replaceKey()
      
      if currentChildren[key]?.count > 0 {
        let replacement = currentChildren[key]!.removeFirst()
        assert(replacement.node.description.replaceKey() == newChild.replaceKey())
        
        try! replacement.node.update(description: newChild)
        
        nodes.append(replacement.node)
        viewIndex.append(replacement.index)
        
      } else {
        //else create a new node
        let node = newChild.node(parentNode: self)
        viewIndex.append(children.count + nodesToRender.count)
        nodes.append(node)
        nodesToRender.append(node)
      }
    }
    
    self.children = nodes
    
    self.redraw(childrenToAdd: nodesToRender, viewIndexes: viewIndex)
  }
  
  public func draw(container: DrawableContainer) {
    guard let children = self.children else {
      fatalError("draw cannot be called at this time")
    }
    
    if (self.container != nil)  {
      fatalError("draw can only be call once on a node")
    }
    
    self.container = container.add { Description.NativeView() }
    
    self.container?.update { view in
      Description.applyPropsToNativeView(props: self.typedDescription.props,
                             state: self.state,
                             view: view as! Description.NativeView,
                             update: self.update,
                             node: self)
    }
    
    children.forEach { $0.draw(container: self.container!) }
  }
  
  
  public func redraw(childrenToAdd: [AnyNode], viewIndexes: [Int]) {
    guard let container = self.container else {
      return
    }
    
    assert(viewIndexes.count == self.children?.count)
    
    container.update { view in
      Description.applyPropsToNativeView(props: self.typedDescription.props,
                             state: self.state,
                             view: view as! Description.NativeView,
                             update: self.update,
                             node: self)
      
    }
    
    childrenToAdd.forEach { node in
      return node.draw(container: container)
    }
    
    var currentSubviews : [DrawableContainerChild?] =  container.children().map { $0 }
    let sorted = viewIndexes.isSorted
    
    for viewIndex in viewIndexes {
      let currentSubview = currentSubviews[viewIndex]!
      if (!sorted) {
        container.bringToFront(child: currentSubview)
      }
      currentSubviews[viewIndex] = nil
    }
    
    for view in currentSubviews {
      if let viewToRemove = view {
        self.container?.remove(child: viewToRemove)
      }
    }
  }
  
  public func getPlasticMultiplier() -> CGFloat {
    guard let description = self.typedDescription as? PlasticReferenceSizeNodeDescription else {
      return self.parentNode?.getPlasticMultiplier() ?? 0.0
    }
    
    let referenceSize = description.dynamicType.referenceSize()
    let currentSize = self.typedDescription.frame
    
    let widthRatio = currentSize.width / referenceSize.width;
    let heightRatio = currentSize.height / referenceSize.height;
    return min(widthRatio, heightRatio);
  }
  
  func processChildrenBeforeDraw(_ children: [AnyNodeDescription]) -> [AnyNodeDescription] {
    return children
  }
}
