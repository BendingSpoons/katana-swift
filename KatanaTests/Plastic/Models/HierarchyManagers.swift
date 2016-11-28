//
//  HierarchyManagers.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import CoreGraphics
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
