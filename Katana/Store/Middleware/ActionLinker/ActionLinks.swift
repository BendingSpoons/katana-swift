//
//  ActionLinks.swift
//  Katana
//
//  Created by Riccardo Cipolleschi on 11/01/2017.
//  Copyright © 2017 Bending Spoons. All rights reserved.
//

import Foundation

/**
 A struct that contains the link source and all the linked actions that depends on the first one.
 */
public struct ActionLinks {
  
  ///Action type that is the source of the link.
  let source: Action.Type
  
  ///All the actions that must be dispatched after the source has been triggered.
  let links: [LinkeableAction.Type]

  init(source: Action.Type, links: [LinkeableAction.Type]) {
    self.source = source
    self.links = links
  }
}
