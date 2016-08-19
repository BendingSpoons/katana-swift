//
//  PlasticViewsContainer+Helpers.swift
//  Katana
//
//  Created by Mauro Bolis on 18/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public extension ViewsContainer {
  public func filter(_ filter: (String) -> Bool) -> [String: PlasticView] {
    var newDict = [String: PlasticView]()
    
    for (key, view) in self.views {
      if filter(key) {
        newDict[key] = view
      }
    }
    
    return newDict
  }
  
  
  // return an ordered array of items that have a certain prefix
  public func orderedViews(withPrefix prefix: String, sortedBy sort: (String, String) -> Bool) -> [PlasticView] {
    return self.views
      .filter { $0.key.hasPrefix(prefix) }
      .sorted { sort($0.key, $1.key) }
      .flatMap { self[$0.key] }
    }
}
