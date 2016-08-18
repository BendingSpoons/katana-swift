//
//  Node.swift
//  Katana
//
//  Created by Luca Querella on 09/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

public protocol AnyNode: class, ReferenceViewProvider {
  var description : AnyNodeDescription {get}
  func render(container: RenderContainer)
  func update(description: AnyNodeDescription) throws
}

public class Node<Description:NodeDescription> : AnyNode {
  private var _description : Description
  private var children : [AnyNode]?
  private var state : Description.State
  private var container: RenderContainer?
  weak private var parentNode: AnyNode?
  
  public var description: AnyNodeDescription {
    get {
      return self._description
    }
  }
  
  public init(description: Description, parentNode: AnyNode?) {
    self._description = description
    self.state = Description.initialState
    self.parentNode = parentNode
    
    let children  = Description.render(props: self._description.props,
                                       state: self.state,
                                       children: self._description.children,
                                       update: self.update)
    
    let nChildren = self.applyLayout(to: children)
    self.children = nChildren.map { $0.node(parentNode: self) }
  }
  
  private func update(state: Description.State)  {
    self.update(state: state, description: self._description)
  }
  
  public func update(description: AnyNodeDescription) throws {
    let description = description as! Description
    self.update(state: self.state, description: description)
  }
  
  func update(state: Description.State, description: Description) {
    
    
    guard let children = self.children else {
      fatalError("update should not be called at this time")
    }
    
    let sameProps = self._description.props == description.props
    let sameState = self.state == state
    let sameChildren = self._description.children.count + description.children.count == 0
    
    
    if (sameProps && sameState && sameChildren) {
      return
    }
    
    self._description = description
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
    
    
    var newChildren = Description.render(props: self._description.props,
                                         state: self.state,
                                         children: self._description.children,
                                         update: self.update)
    
    newChildren = applyLayout(to: newChildren)
    
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
    
    self.updateRender(applyProps: (!(sameProps && sameState)),
                      childrenToRender: nodesToRender,
                      viewIndexes: viewIndex)
    
    
    
  }
  
  public func render(container: RenderContainer) {
    
    guard let children = self.children else {
      fatalError("render cannot be called at this time")
    }
    
    if (self.container != nil)  {
      fatalError("node can be render on a single View")
    }
    
    
    self.container = container.add { Description.NativeView() }
    self.container?.update { view in
      
      Description.renderView(props: self._description.props,
                             state: self.state,
                             view: view as! Description.NativeView,
                             update: self.update)
    }
    
    children.forEach { $0.render(container: self.container!) }
  }
  
  
  public func updateRender(applyProps: Bool, childrenToRender: [AnyNode], viewIndexes: [Int]) {
    
    guard let container = self.container else {
      return
    }
    
    assert(viewIndexes.count == self.children?.count)
    
    if (applyProps)  {
      container.update { view in
        Description.renderView(props: self._description.props,
                               state: self.state,
                               view: view as! Description.NativeView,
                               update: self.update)
        
      }
    }
    
    childrenToRender.forEach { node in
      return node.render(container: container)
    }
    
    
    var currentSubviews : [RenderContainerChild?] =  container.children().map { $0 }
    let sorted = viewIndexes.isSorted()
    
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
}

// MARK: Plastic
extension Node {
  private func applyLayout(to children: [AnyNodeDescription]) -> [AnyNodeDescription] {
    
    guard let description = self._description as? AnyPlasticNodeDescription else {
      // the node is not conforming to plastic, just return the children as is
      return children
    }
    
    let container = ViewsContainer(rootFrame: self._description.props.frame, children: children, multiplier: self.getPlasticMultiplier())
    
    description.dynamicType._layout(views: container, props: self._description.props, state: self.state)
    
    return self.getFramedChildren(fromChildren: children, usingContainer: container)
  }
  
  private func getFramedChildren(fromChildren children: [AnyNodeDescription], usingContainer container: ViewsContainer) -> [AnyNodeDescription] {
    
    return children.map {
      var newChild = $0
      
      if let key = newChild.key {
        // if key is not in container we would throw an exception anyway
        let frame = container[key]!.frame
        newChild.frame = frame
      }
      
      newChild.children = self.getFramedChildren(fromChildren: $0.children, usingContainer: container)
      
      return newChild
    }
  }
  
  public func getPlasticMultiplier() -> CGFloat {
    guard let description = self._description as? ReferenceNodeDescription else {
      return self.parentNode?.getPlasticMultiplier() ?? 0.0
    }
    
    
    let referenceSize = description.dynamicType.referenceSize()
    let currentSize = self._description.frame
    
    let widthRatio = currentSize.width / referenceSize.width;
    let heightRatio = currentSize.height / referenceSize.height;
    return min(widthRatio, heightRatio);
  }
}
