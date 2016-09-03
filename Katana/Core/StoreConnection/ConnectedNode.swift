//
//  ConnectedNode.swift
//  Katana
//
//  Created by Mauro Bolis on 19/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation


protocol ConnectedNode : AnyNode {
  func storeDidChange()
}

extension ConnectedNode {
  func storeDidChange() {
    if self.anyDescription is AnyConnectedNodeDescription {
      // ok the description is connected to the node, let's trigger an update
      try! self.update(description: self.anyDescription)
    }
  }
}
