//
//  HierarchyManager.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

// protocol used to emulate the hierarchy methods
// that UIKit offers. Whoever implements this method should act as  UIKit
// and provide conversion from relative to absolute coordinate
// UIKit offers method to translate coords from a coordinate system to another,
// we don't need all this freedom since our use case is way more restricted
protocol HierarchyManager: class {
  func relativeXCoordinate(_ absoluteValue: CGFloat, forViewWithKey: String) -> CGFloat
  func relativeYCoordinate(_ absoluteValue: CGFloat, forViewWithKey: String) -> CGFloat
}
