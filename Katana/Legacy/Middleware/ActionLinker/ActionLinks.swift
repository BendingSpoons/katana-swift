//
//  ActionLinks.swift
//  Katana
//
//  Copyright © 2017 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

/**
 A struct that contains the link source and all the linked actions that depends on the first one.
 */
@available(*, deprecated, message: "Use DispatchObserverDispatchable instead")
public struct ActionLinks {
  
  ///Action type that is the source of the link.
  let source: Action.Type
  
  ///All the actions that must be dispatched after the source has been triggered.
  let links: [LinkeableAction.Type]

  /**
   Initializer to create an ActionLinks.
   It must be public so other libs can export their own links.
   
   - parameter source: the Action.Type that is the source of the link.
   - parameter links: the array of dependant actions that should be invoked after the first.
   */
  public init(source: Action.Type, links: [LinkeableAction.Type]) {
    self.source = source
    self.links = links
  }
}
