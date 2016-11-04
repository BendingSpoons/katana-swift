//
//  PlasticViewsContainer+Helpers.swift
//  Katana
//
//  Created by Mauro Bolis on 18/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

/// Extension of `ViewsContainer` with some helper methods
public extension ViewsContainer {
  
  /**
   Returns the views contained in the ViewsContainer that passes the filter
   
   - parameter filter: a closure that returns whether the view associated with the key
                       should be in the final result or not
   
   - returns: a dictionary with all the views that have passed the filter. They key of the dictionary
              is the key associated with the node description (and therefore to the view)
  */
  public func filtered(with filter: (String) -> Bool) -> [String: PlasticView] {
    var newDict = [String: PlasticView]()
    
    for (key, view) in self.views {
      if filter(key) {
        newDict[key] = view
      }
    }
    
    return newDict
  }
  
  
  /**
   Returns an array of views that passes the filter, and ordered using the `sort` closure
   
   - parameter filter: the filter to apply to the views
   - parameter sort:   a closure that that can be used to sort the view's keys
   
   - note: you can use standard Swift operators such as `>` or `<` as `sort` parameter
  */
  public func orderedViews(filter: (String) -> Bool, sortedBy sort: (String, String) -> Bool) -> [PlasticView] {
    return self
      .filtered(with: filter)
      .map { $0.key }
      .sorted()
      .flatMap { self.views[$0] }
    }
}
