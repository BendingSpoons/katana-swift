//
//  PlasticViewsContainer+Helpers.swift
//  Katana
//
//  Created by Mauro Bolis on 18/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public extension ViewsContainer {
  public func filtered(with filter: (String) -> Bool) -> [String: PlasticView] {
    var newDict = [String: PlasticView]()
    
    for (key, view) in self.views {
      if filter(key) {
        newDict[key] = view
      }
    }
    
    return newDict
  }
  
  
  // return an ordered array of items that have a certain prefix
  public func orderedViews(filter: (String) -> Bool, sortedBy sort: (String, String) -> Bool) -> [PlasticView] {
    return self
      .filtered(with: filter)
      .map { $0.key }
      .sorted()
      .flatMap { self.views[$0] }
    }
}
