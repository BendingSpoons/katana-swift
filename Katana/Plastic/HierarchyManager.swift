//
//  HierarchyManager.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

// protocol used to emulate the hierarchy methods
// that UIKit offers. Whoever implements this method should act as  UIKit
// and provide conversion from relative to absolute coordinate
// UIKit offers method to translate coords from a coordinate system to another,
// we don't need all this freedom since our use case is way more restricted
protocol CoordinateConvertible: class {
  // return absolute value in the coordinate system of the parent of the given key
  // the absolute value is considered as x value
  func getXCoordinate(_ absoluteValue: CGFloat, inCoordinateSystemOfParentOfKey key: String) -> CGFloat
  
  // return absolute value in the coordinate system of the parent of the given key
  // the absolute value is considered as x value
  func getYCoordinate(_ absoluteValue: CGFloat, inCoordinateSystemOfParentOfKey key: String) -> CGFloat
}
