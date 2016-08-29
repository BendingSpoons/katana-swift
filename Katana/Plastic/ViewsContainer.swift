//
//  PlasticViewsContainer.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

private let ROOT_KEY = "//ROOT_KEY\\"

internal enum HierarchyNode<Key> where Key : RawRepresentable & Hashable {
  // the node is the root node
  case root
  
  // the node is something with a static frame (no key)
  // we save the frame of the node and the reference to the parent
  indirect case staticFrame(CGRect, HierarchyNode<Key>)
  
  // the node is something with a dynamic frame (managed by plastic)
  case dynamicFrame(Key)
}

public class ViewsContainer<Key> : HierarchyManager
  where Key : RawRepresentable & Hashable & Comparable {
  
  // an association between the key and the plastic view
  private(set) var views: [Key: PlasticView] = [:]
  
  // the key is the node key while the value is a parent node representation
  private var hierarchy: [Key: HierarchyNode<Key>] = [:]
  
  private let rootFrame: CGRect
  private let multiplier: CGFloat

  lazy public private(set) var rootView: PlasticView = {
    return PlasticView(
      hierarchyManager: self,
      key: ROOT_KEY,
      multiplier: self.multiplier,
      frame: self.rootFrame
    )
  }()

  init(rootFrame: CGRect, children: [AnyNodeDescription], multiplier: CGFloat) {
    self.rootFrame = rootFrame
    self.multiplier = multiplier
    
    // create children placeholders
    flattenChildren(children).forEach { key,node in

      let enumKey = Key.init(rawValue: key as! Key.RawValue)!

      self.views[enumKey] = PlasticView(
        hierarchyManager: self,
        key: key,
        multiplier: multiplier,
        frame: node.frame
      )
    }
    
    // this is a kind of workaround.. basically in this way we automatically handle the root
    self.nodeChildrenHierarchy(children, parentRepresentation: .root, accumulator: &hierarchy)
  }
  
  public subscript(key: Key) -> PlasticView? {
    return self.views[key]
  }

  func getXCoordinate(_ absoluteValue: CGFloat, inCoordinateSystemOfParentOfKey key: String) -> CGFloat {
    let enumKey = Key.init(rawValue: key as! Key.RawValue)!
    
    guard let node = self.hierarchy[enumKey] else {
      fatalError("\(key) is not a valid node key")
    }
    
    let origin = self.resolveAbsoluteOrigin(fromNode: node)
    return absoluteValue - origin.x
  }

  func getYCoordinate(_ absoluteValue: CGFloat, inCoordinateSystemOfParentOfKey key: String) -> CGFloat {
    let enumKey = Key.init(rawValue: key as! Key.RawValue)!
    
    guard let node = self.hierarchy[enumKey] else {
      fatalError("\(key) is not a valid node key")
    }
    
    let origin = self.resolveAbsoluteOrigin(fromNode: node)
    return absoluteValue - origin.y
  }
  
  /*
    This method basically explores the node hierarchy and returns the absolute origin of the node.
    Two cases are trivial: root and managed by plastic (since plastic already holds an absolute value).
    When we have static frames (node without keys) we need to explore the hierarchy until we either find the root or a plastic node
  */
  private func resolveAbsoluteOrigin(fromNode node: HierarchyNode<Key>) -> CGPoint {
    switch node {
    case .root:
      return self.rootFrame.origin
      
    case let .dynamicFrame(key):
      guard let node = self[key] else {
        fatalError("\(key) is not a valid node key")
      }
      
      return node.absoluteOrigin
      
      
    case let .staticFrame(frame, parentNode):
      let parentOrigin = self.resolveAbsoluteOrigin(fromNode: parentNode)
      let currentOrigin = frame.origin
      return CGPoint(x: parentOrigin.x + currentOrigin.x, y: parentOrigin.y + currentOrigin.y)
    }
  }
}

internal extension ViewsContainer {
  internal func flattenChildren(_ children: [AnyNodeDescription]) -> [(String, AnyNodeDescription)] {
    return children.reduce([], { (partialResult, node) -> [(String, AnyNodeDescription)] in
      
      var flatChildren: [(String, AnyNodeDescription)] = []
      
      if let n = node as? AnyNodeWithChildrenDescription {
        flatChildren = self.flattenChildren(n.children)
      }
      
      guard let key = node.key else {
        return partialResult + flatChildren
      }
      
      return partialResult + [(key, node)] + flatChildren
    })
  }
  
  /*
   This method creates the hierarchy of the nodes.
   It populates the accumulator with items where the key is the key of a node and the value a pointer to the parent.
   This pointer can be of three types:
   - Root: the parent is the root
   - StaticFrame: the parent is a node without key, we assume that the frame is static
   - DynamicFrame: the parent is a node with a key, it is managed by plastic
   */
  internal func nodeChildrenHierarchy(_ children: [AnyNodeDescription], parentRepresentation: HierarchyNode<Key>, accumulator: inout [Key: HierarchyNode<Key>]) -> Void {
    
    children.forEach { node in
      
      let currentNode: HierarchyNode<Key> = {
        if let key = node.key {
          return .dynamicFrame(key.toEnumRawValue())
        }
        
        return .staticFrame(node.frame, parentRepresentation)
      }()
      
      
      if let key = node.key {
        // if the node has a key, let's add it to the accumulator
        let enumKey = Key.init(rawValue: key as! Key.RawValue)!
        accumulator[enumKey] = parentRepresentation
      }
      
      if let n = node as? AnyNodeWithChildrenDescription {
        nodeChildrenHierarchy(n.children, parentRepresentation: currentNode, accumulator: &accumulator)
      }
    }
  }
}

internal extension String {
  // as before, this is just sugar syntax to avoid checks we know are already satisfied by
  // the viewsContainer checks
  internal func toEnumRawValue<Key: RawRepresentable>() -> Key {
    return Key.init(rawValue: self as! Key.RawValue)!
  }
}
