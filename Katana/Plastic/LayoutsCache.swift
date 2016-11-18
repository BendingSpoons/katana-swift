//
//  LayoutsCache.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import CoreGraphics

/// `CGSize` extension that makes it hashable
extension CGSize: Hashable {
  public var hashValue: Int {
    return
      self.width.hashValue ^
      self.height.hashValue
  }
}

/**
  Struct used as key of the layout cache.
  Every instance is related to node description in a given context.
  The key captures the part of the context that is relevant to understand
  whether a cached layout can be reused or not
*/
fileprivate struct CacheKey: Hashable {
  /// The native view size of the node description
  let nativeViewSize: CGSize
  
  /// The multiplier used to calculate the layout
  let multiplier: CGFloat
  
  /// The layout hash returned by the node description
  let layoutHash: Int
  
  /// The node description hash
  let nodeDescriptionHash: Int
  
  /// the hash value of the instance
  var hashValue: Int {
    return
      self.nativeViewSize.hashValue ^
        self.multiplier.hashValue ^
        self.layoutHash ^
        self.nodeDescriptionHash
  }
  
  /**
   Imlementation of the `Equatable` protocol.
   
   - parameter lhs: the first instance
   - parameter rhs: the second instance
   - returns: true if the two instances are equal
   */
  static func == (l: CacheKey, r: CacheKey) -> Bool {
    return
      l.nodeDescriptionHash == r.nodeDescriptionHash &&
        l.nativeViewSize == r.nativeViewSize &&
        l.multiplier == r.multiplier &&
        l.layoutHash == r.layoutHash
  }
}


/// A container for all the application cached layouts
class LayoutsCache {

  /// Singleton to use in the application
  static let shared = LayoutsCache()
  
  /// A dictionary that contains the cached layout results
  fileprivate var cache: [CacheKey: [String: CGRect]]
  
  /// Init for the cache
  private init() {
    self.cache = [:]
  }
  
  /**
   Add a new layout result to the cache
   
   - parameter layoutHash:      the hash returned by the `PlasticNodeDescription` `layout(props:state:)` method
   - parameter nativeViewFrame: the frame of the native view used to calculate the layout
   - parameter multiplier:      the multiplier used to calculate the layout
   - parameter nodeDescription: the node description for which the layout has been calculated
   - parameter frames:          the result of the layout operation
  */
  func cacheLayout(layoutHash: Int,
              nativeViewFrame: CGRect,
                   multiplier: CGFloat,
              nodeDescription: AnyNodeDescription,
              frames: [String: CGRect]) {
    
    let nodeHash = ObjectIdentifier(type(of: nodeDescription)).hashValue
    
    let key = CacheKey(
      nativeViewSize: nativeViewFrame.size,
      multiplier: multiplier,
      layoutHash: layoutHash,
      nodeDescriptionHash: nodeHash
    )
    
    self.cache[key] = frames
  }
  
  /**
   Retrieves the a cached layout result that is compatible with the given parameters
   
   - parameter layoutHash:      the hash returned by the `PlasticNodeDescription` `layout(props:state:)` method
   - parameter nativeViewFrame: the frame of the native view for which we want the layout cache
   - parameter multiplier:      the multiplier for which we want the layout cache
   - parameter nodeDescription: the node description for which we want the layout cache
   - returns: If it is possible to retrieve a layout cache, a dictionary where the key is the key
              of the node description and the value is the frame to use for that node description.
              `nil` otherwise.
  */
  func getCachedLayout(layoutHash: Int,
                  nativeViewFrame: CGRect,
                       multiplier: CGFloat,
                  nodeDescription: AnyNodeDescription) -> [String: CGRect]? {
    
    let nodeHash = ObjectIdentifier(type(of: nodeDescription)).hashValue
    
    let key = CacheKey(
      nativeViewSize: nativeViewFrame.size,
      multiplier: multiplier,
      layoutHash: layoutHash,
      nodeDescriptionHash: nodeHash
    )
    
    return self.cache[key]
  }
}
