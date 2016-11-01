//
//  PlasticViewsContainer.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

private let nativeViewKey = "//NATIVEVIEWKEY\\"

internal enum HierarchyNode {
  // the node is the native node
  case nativeView
  
  // the node is something with a static frame (no key)
  // we save the frame of the node and the reference to the parent
  indirect case staticFrame(CGRect, HierarchyNode)
  
  // the node is something with a dynamic frame (managed by plastic)
  case dynamicFrame(String)
}

public class ViewsContainer<Key>: HierarchyManager {
//where Key: RawRepresentable & Hashable & Comparable {

  // an association between the key and the plastic view
  private(set) var views: [String: PlasticView] = [:]
  
  // the key is the node key while the value is a parent node representation
  private var hierarchy: [String: HierarchyNode] = [:]
  private var flatChildren: [(String, AnyNodeDescription)]
  private var children: [AnyNodeDescription]
  
  private let nativeViewFrame: CGRect
  private let multiplier: CGFloat
  
  lazy public var nativeView: PlasticView = {
    return PlasticView(
      hierarchyManager: self,
      key: nativeViewKey,
      multiplier: self.multiplier,
      frame: self.nativeViewFrame
    )
  }()
  
  var childrenKeys: [String] {
    return self.flatChildren.map { $0.0 }
  }
  
  var frames: [String: CGRect] {
    var frames = [String: CGRect]()
    
    for (key, value) in self.views {
      frames["\(key)"] = value.frame
    }
    
    return frames
  }
  
  init(nativeViewFrame: CGRect, children: [AnyNodeDescription], multiplier: CGFloat) {
    self.nativeViewFrame = nativeViewFrame
    self.multiplier = multiplier
    self.children = children
    
    // create children placeholders
    self.flatChildren = [(String, AnyNodeDescription)]()
    flattenChildren(children, accumulator: &self.flatChildren)
  }
  
  func initialize() {
    self.flatChildren.forEach { key, node in
      self.views[key] = PlasticView(
        hierarchyManager: self,
        key: key,
        multiplier: multiplier,
        frame: node.frame
      )
    }
    
    self.nodeChildrenHierarchy(self.children, parentRepresentation: .nativeView, accumulator: &hierarchy)
  }
  
  public subscript(key: Key) -> PlasticView? {
    return self.views["\(key)"]
  }
  
  func getXCoordinate(_ absoluteValue: CGFloat, inCoordinateSystemOfParentOfKey key: String) -> CGFloat {
    guard let node = self.hierarchy[key] else {
      fatalError("\(key) is not a valid node key")
    }
    
    let origin = self.resolvedAbsoluteOrigin(for: node)
    return absoluteValue - origin.x
  }
  
  func getYCoordinate(_ absoluteValue: CGFloat, inCoordinateSystemOfParentOfKey key: String) -> CGFloat {
    guard let node = self.hierarchy[key] else {
      fatalError("\(key) is not a valid node key")
    }
    
    let origin = self.resolvedAbsoluteOrigin(for: node)
    return absoluteValue - origin.y
  }
  
  /*
   This method basically explores the node hierarchy and returns the absolute origin of the node.
   Two cases are trivial: root and managed by plastic (since plastic already holds an absolute value).
   When we have static frames (node without keys) we need to explore the hierarchy until we either find the root or a plastic node
   */
  private func resolvedAbsoluteOrigin(for node: HierarchyNode) -> CGPoint {
    switch node {
    case .nativeView:
      return self.nativeViewFrame.origin
      
    case let .dynamicFrame(key):
      guard let node = self.views[key] else {
        fatalError("\(key) is not a valid node key")
      }
      
      return node.absoluteOrigin
      
      
    case let .staticFrame(frame, parent):
      let parentOrigin = self.resolvedAbsoluteOrigin(for: parent)
      let currentOrigin = frame.origin
      return CGPoint(x: parentOrigin.x + currentOrigin.x, y: parentOrigin.y + currentOrigin.y)
    }
  }
}

internal extension ViewsContainer {
  internal func flattenChildren(_ children: [AnyNodeDescription], accumulator: inout [(String, AnyNodeDescription)]) {
    for node in children {
      if let n = node as? AnyNodeDescriptionWithChildren {
        self.flattenChildren(n.children, accumulator: &accumulator)
      }
      
      if let key = node.key {
        accumulator.append((key, node))
      }
    }
  }
  
  /*
   This method creates the hierarchy of the nodes.
   It populates the accumulator with items where the key is the key of a node and the value a pointer to the parent.
   This pointer can be of three types:
   - Root: the parent is the root
   - StaticFrame: the parent is a node without key, we assume that the frame is static
   - DynamicFrame: the parent is a node with a key, it is managed by plastic
   */
  internal func nodeChildrenHierarchy(_ children: [AnyNodeDescription],
                            parentRepresentation: HierarchyNode,
                                     accumulator: inout [String: HierarchyNode]) -> Void {
    
    children.forEach { node in
      
      let currentNode: HierarchyNode = {
        if let key = node.key {
          return .dynamicFrame(key)
        }
        
        return .staticFrame(node.frame, parentRepresentation)
      }()
      
      
      if let key = node.key {
        accumulator[key] = parentRepresentation
      }
      
      if let n = node as? AnyNodeDescriptionWithChildren {
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
