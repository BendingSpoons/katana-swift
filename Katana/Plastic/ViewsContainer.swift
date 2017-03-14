//
//  PlasticViewsContainer.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import CoreGraphics

/// Internal key used to store and retrieve the native view
private let nativeViewKey = "//NATIVEVIEWKEY\\"

/**
 Enum used to describe the hierarchy of the node descriptions managed by
 the `ViewsContainer`
*/
internal enum HierarchyNode {
  /// The node is the native node
  case nativeView

  /**
    The node is something with a static frame (no key) we save the frame of
    and the reference to the parent
  */
  indirect case staticFrame(CGRect, HierarchyNode)

  /// The node is something with a dynamic frame (managed by plastic)
  case dynamicFrame(String)
}

/**
 This class is used to encapsulate the logic to store and retrieve `PlasticView` instances
 during the `layout` operation. In general, a `ViewsContainer` is related to a single `NodeDescription`
 instance, and the managed views are the descriptions of the children.
 
 It is generic over the `Key` parameter to enforce the type checking
 in the subscript used to retrieve the instances of `PlasticView`.
 
 The typical usage in a layout of a `ViewsContainer` instance is the following:
 
 ```
 // to get the native view
 let nativeView = views.nativeView
 
 // to get the PlasticView instance related to `.key`
 let keyView = views[.key] // please note that an optional value is returned
 ```
 
 - seeAlso: `PlasticNodeDescription`
*/
public class ViewsContainer<Key> {

  /// Dictionary that associates the node description key to the correspondent `PlasticView` instance
  fileprivate(set) var views: [String: PlasticView] = [:]

  /// Dictionary used to store the relation between a node description key and its type
  fileprivate var hierarchy: [String: HierarchyNode] = [:]

  /**
    An array of tuples where the first value is the key of the node description
    and the value is the node description itself
  */
  private var flatChildrenDescriptions: [(String, AnyNodeDescription)]

  /// The list of node descriptions managed by the container
  private var childrenDescriptions: [AnyNodeDescription]

  /// The frame of the native view
  private let nativeViewFrame: CGRect

  /// The multiplier to use in the scaling operations
  private let multiplier: CGFloat

  /// The `PlasticView` instance related to the native view
  lazy public var nativeView: PlasticView = {
    return PlasticView(
      hierarchyManager: self,
      key: nativeViewKey,
      multiplier: self.multiplier,
      frame: self.nativeViewFrame
    )
  }()

  /**
   The frames of the views managed by the container.
   The keys of the dictionary are the keys associated with the node descriptions while
   the values are the frames that should be assigned to each node description
  */
  var frames: [String: CGRect] {
    var frames = [String: CGRect]()

    for (key, value) in self.views {
      frames["\(key)"] = value.frame.retinaRounded
    }

    return frames
  }

  /**
   Creates a new `ViewsContainer` instance with the given values
   
   - parameter nativeViewFrame:      the frame of the native view
   - parameter childrenDescriptions: the node descriptions of the children, which will be used in the layout
   - parameter multiplier:           the multiplier to use in the scaling operations
   - returns: a valid instance of `ViewsContainer`
   
   - warning: Please note that the returned instance is not ready to be used in the layout operation.
              Additional operations should be performed. The initializer doesn't perform them
              immediately for performance reasons. Invoke `initialize()` to prepare the instance to be used in the layout
  */
  init(nativeViewFrame: CGRect, childrenDescriptions: [AnyNodeDescription], multiplier: CGFloat) {
    self.nativeViewFrame = nativeViewFrame
    self.multiplier = multiplier
    self.childrenDescriptions = childrenDescriptions

    // create children placeholders
    self.flatChildrenDescriptions = [(String, AnyNodeDescription)]()
    flattenChildren(childrenDescriptions, accumulator: &self.flatChildrenDescriptions)
  }

  /// Prepares all the necessary data structures to use the instance in a layout operation
  func initialize() {
    self.flatChildrenDescriptions.forEach { key, node in
      self.views[key] = PlasticView(
        hierarchyManager: self,
        key: key,
        multiplier: multiplier,
        frame: node.anyProps.frame
      )
    }

    self.createChildrenHierarchy(for: self.childrenDescriptions, parentRepresentation: .nativeView, accumulator: &hierarchy)
  }

  /**
   Gets the `PlasticView` instance related to the given key
   
   - parameter key: the key of the instance to retrieve
   - returns: an optional of `PlasticView`.
              It is a valid instance if given key is associated with a node description returned
              in the `NodeDescription` `childrenDescriptions(props:state:update:dispatch:)` method. The optional
              is empty in any other case
  */
  public subscript(key: Key) -> PlasticView? {
    return self.views["\(key)"]
  }

  /**
   This method basically explores the node descriptions hierarchy and returns the absolute origin of the node.
   Two cases are trivial: root and managed by plastic (since plastic already holds an absolute value).
   
   When we have static frames (node without keys) we need to explore the hierarchy until we either find the root or a plastic node
   
   - parameter node: the node description representation 
   - returns: the origin of `node` in the native view coordinate system
  */
  fileprivate func resolvedAbsoluteOrigin(for node: HierarchyNode) -> CGPoint {
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

extension ViewsContainer: CoordinateConvertible {
  /**
   Implementation of the CoordinateConvertible protocol.
   
   - seeAlso: `CoordinateConvertible`
   */
  func getXCoordinate(_ absoluteValue: CGFloat, inCoordinateSystemOfParentOfKey key: String) -> CGFloat {
    guard let node = self.hierarchy[key] else {
      fatalError("\(key) is not a valid node key")
    }

    let origin = self.resolvedAbsoluteOrigin(for: node)
    return absoluteValue - origin.x
  }

  /**
   Implementation of the CoordinateConvertible protocol.
   
   - seeAlso: `CoordinateConvertible`
   */
  func getYCoordinate(_ absoluteValue: CGFloat, inCoordinateSystemOfParentOfKey key: String) -> CGFloat {
    guard let node = self.hierarchy[key] else {
      fatalError("\(key) is not a valid node key")
    }

    let origin = self.resolvedAbsoluteOrigin(for: node)
    return absoluteValue - origin.y
  }
}

extension ViewsContainer {
  /**
   Returns a flat array of children. This method explores every node description's children if they implement the 
  `NodeDescriptionWithChildren` protocol
   
   - parameter children:    the children to explore
   - parameter accumulator: the accumulator where to store the children
  */
  internal func flattenChildren(_ children: [AnyNodeDescription], accumulator: inout [(String, AnyNodeDescription)]) {
    for node in children {
      if let n = node as? AnyNodeDescriptionWithChildren {
        self.flattenChildren(n.children, accumulator: &accumulator)
      }

      if let key = node.anyProps.key {
        accumulator.append((key, node))
      }
    }
  }

  /**
   This method creates the hierarchy of the nodes.
   It populates the accumulator with items where the key is the key of a node and the value a pointer to the parent.
   This pointer can be of three types:
   - Root: the parent is the root
   - StaticFrame: the parent is a node without key, we assume that the frame is static
   - DynamicFrame: the parent is a node with a key, it is managed by plastic
   
   - parameter childrenDescriptions: the list of children for which we need to create the hierarchy
   - parameter parentRepresentation: the type of the parent of the given children
   - parameter accumulator:          the accumulator where to store the hierarchy
   */
  internal func createChildrenHierarchy(for childrenDescriptions: [AnyNodeDescription],
                            parentRepresentation: HierarchyNode,
                                     accumulator: inout [String: HierarchyNode]) {

    childrenDescriptions.forEach { nodeDescription in

      let currentRepresentation: HierarchyNode = {
        if let key = nodeDescription.anyProps.key {
          return .dynamicFrame(key)
        }

        return .staticFrame(nodeDescription.anyProps.frame, parentRepresentation)
      }()

      if let key = nodeDescription.anyProps.key {
        accumulator[key] = parentRepresentation
      }

      if let nodeDescription = nodeDescription as? AnyNodeDescriptionWithChildren {
        createChildrenHierarchy(for: nodeDescription.children,
                                parentRepresentation: currentRepresentation,
                                accumulator: &accumulator)
      }
    }
  }
}

fileprivate extension CGRect {
  
  /**
   Round the CGRect value to the closest possible decimal
   value allowed by the retina scale
   */
  fileprivate var retinaRounded: CGRect {
    return CGRect(
      x: self.origin.x.retinaRounded,
      y: self.origin.y.retinaRounded,
      width: self.size.width.retinaRounded,
      height: self.size.height.retinaRounded
    )
  }
}

fileprivate extension CGFloat {
  
  /**
    Round the CGFloat value to the closest possible decimal
    value allowed by the retina scale
  */
  var retinaRounded: CGFloat {
    return (self * Screen.retinaScale).rounded() / Screen.retinaScale
  }
}
