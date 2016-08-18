//
//  PlasticViewsContainer.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

private let ROOT_KEY = "//ROOT_KEY\\"

private enum HierarchyNode {
  // the node is the root node
  case Root
  
  // the node is something with a static frame (no key)
  // we save the frame of the node and the reference to the parent
  indirect case StaticFrame(CGRect, HierarchyNode)
  
  // the node is something with a dynamic frame (managed by plastic)
  case DynamicFrame(String)
}

public class PlasticViewsContainer {
  private(set) var views: [String: PlasticView] = [:]
  
  // the key is the node key while the value is a parent node representation
  private var hierarchy: [String: HierarchyNode] = [:]
  
  public var rootView: PlasticView {
    return self.views[ROOT_KEY]!
  }

  init(rootFrame: CGRect, children: [AnyNodeDescription], multiplier: CGFloat) {
    // root element
    self.views[ROOT_KEY] = PlasticView(
      hierarchyManager: self,
      key: ROOT_KEY,
      multiplier: multiplier,
      frame: rootFrame
    )
    
    // create children placeholders
    flattenChildren(children).forEach { (key, node) in
      self.views[key] = PlasticView(
        hierarchyManager: self,
        key: key,
        multiplier: multiplier,
        frame: node.frame
      )
    }
    
    // this is a kind of workaround.. basically in this way we automatically handle the root
    hierarchy[ROOT_KEY] = .Root
    self.nodeChildrenHierarchy(children, parentRepresentation: .Root, accumulator: &hierarchy)
  }
  
  public subscript(key: String) -> PlasticView? {
    return self.views[key]
  }
}


// MARK: Hierarchy Manager
extension PlasticViewsContainer: HierarchyManager {
  func getXCoordinate(_ absoluteValue: CGFloat, inCoordinateSystemOfParentOfKey key: String) -> CGFloat {
    guard let node = self.hierarchy[key] else {
      fatalError("\(key) is not a valid node key, this is most likely a bug in Plastic. Open an issue on GithHub")
    }
    
    let origin = self.resolveAbsoluteOrigin(fromNode: node)
    return absoluteValue - origin.x
  }

  func getYCoordinate(_ absoluteValue: CGFloat, inCoordinateSystemOfParentOfKey key: String) -> CGFloat {
    guard let node = self.hierarchy[key] else {
      fatalError("\(key) is not a valid node key, this is most likely a bug in Plastic. Open an issue on GithHub")
    }
    
    let origin = self.resolveAbsoluteOrigin(fromNode: node)
    return absoluteValue - origin.y
  }
  
  /*
    This method basically explores the node hierarchy and returns the absolute origin of the node.
    Two cases are trivial: root and managed by plastic (since plastic already holds an absolute value).
    When we have static frames (node without keys) we need to explore the hierarchy until we either find the root or a plastic node
  */
  private func resolveAbsoluteOrigin(fromNode node: HierarchyNode) -> CGPoint {
    switch node {
    case .Root:
      return CGPoint.zero
      
    case let .DynamicFrame(key):
      guard let node = self[key] else {
        fatalError("\(key) is not a valid node key, this is most likely a bug in Plastic. Open an issue on GithHub")
      }
      
      return node.absoluteOrigin
      
      
    case let .StaticFrame(frame, parentNode):
      let parentOrigin = self.resolveAbsoluteOrigin(fromNode: parentNode)
      let currentOrigin = frame.origin
      return CGPoint(x: parentOrigin.x + currentOrigin.x, y: parentOrigin.y + currentOrigin.y)
    }
  }
}

private extension PlasticViewsContainer {
  private func flattenChildren(_ children: [AnyNodeDescription]) -> [(String, AnyNodeDescription)] {
    return children.reduce([], { (partialResult, node) -> [(String, AnyNodeDescription)] in
      
      let childrenKeys = self.flattenChildren(node.children)
      
      guard let key = node.key else {
        return partialResult + childrenKeys
      }
      
      return partialResult + [(key, node)] + childrenKeys
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
  private func nodeChildrenHierarchy(_ children: [AnyNodeDescription], parentRepresentation: HierarchyNode, accumulator: inout [String: HierarchyNode]) -> Void {
    
    children.forEach { node in
      
      let currentNode: HierarchyNode = {
        if let key = node.key {
          return .DynamicFrame(key)
        }
        
        return .StaticFrame(node.frame, parentRepresentation)
      }()
      
      
      if let key = node.key {
        // if the node has a key, let's add it to the accumulator
        accumulator[key] = parentRepresentation
      }
      
      
      nodeChildrenHierarchy(node.children, parentRepresentation: currentNode, accumulator: &accumulator)
    }
  }
}
