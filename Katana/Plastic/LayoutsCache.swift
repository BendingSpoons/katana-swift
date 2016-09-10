//
//  LayoutsCache.swift
//  Katana
//
//  Created by Mauro Bolis on 09/09/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

extension CGSize: Hashable {
  public var hashValue: Int {
    return
      self.width.hashValue ^
      self.height.hashValue
  }
}

fileprivate struct CacheKey: Hashable {
  let nativeViewSize: CGSize
  let multiplier: CGFloat
  let layoutHash: Int
  let nodeDescriptionHash: Int
  
  var hashValue: Int {
    return
      self.nativeViewSize.hashValue ^
        self.multiplier.hashValue ^
        self.layoutHash ^
        self.nodeDescriptionHash
  }
  
  static func == (l: CacheKey, r: CacheKey) -> Bool {
    return
      l.nodeDescriptionHash == r.nodeDescriptionHash &&
        l.nativeViewSize == r.nativeViewSize &&
        l.multiplier == r.multiplier &&
        l.layoutHash == r.layoutHash
  }
}

class LayoutsCache {
  static let shared = LayoutsCache()
  fileprivate var cache: [CacheKey: [String: CGRect]]
  
  private init() {
    self.cache = [:]
  }
  
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
