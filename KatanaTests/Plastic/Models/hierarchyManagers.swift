//
//  hierarchyManagers.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
@testable import Katana

// dummy hierarchy manager that always like the view
// is the top one.. it always returns the passed value
class DummyHierarchyManager: CoordinateConvertible {
  func getXCoordinate(_ absoluteValue: CGFloat, inCoordinateSystemOfParentOfKey key: String) -> CGFloat {
    return absoluteValue
  }
  
  func getYCoordinate(_ absoluteValue: CGFloat, inCoordinateSystemOfParentOfKey key: String) -> CGFloat {
    return absoluteValue
  }
}
