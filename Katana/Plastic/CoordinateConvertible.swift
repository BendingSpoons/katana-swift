//
//  CoordinateConvertible.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import CoreGraphics

/**
 Protocol used to emulate the hierarchy methods that UIKit/AppKit offers.
 Whoever implements this method should act as UIKit/AppKit and provide conversion
 from relative to absolute coordinate. With absolute coordinate system we mean
 the coordinate system of the native view of a `NodeDescription`
 
 UIKit/AppKit offers method to translate coordinates from a coordinate system to another, we don't need all
 his freedom since our use case is way more restricted
 */
protocol CoordinateConvertible: class {
  /**
   Given the X coordinate in the absolute coordinate system (that is, the coordinate of the
   native view), this method returns the X coordinate in the coordinate system of the view
   represented with the given key.
   
   - parameter absoluteValue: the X coordinate in the absolute coordinate system
   - parameter key:           the key of the view that will be used to calculate the relative X coordinate
   
   - returns: the X coordinate in the `key` view coordinate system
   */
  func getXCoordinate(_ absoluteValue: CGFloat, inCoordinateSystemOfParentOfKey key: String) -> CGFloat

  /**
   Given the Y coordinate in the absolute coordinate system (that is, the coordinate of the
   native view), this method returns the X coordinate in the coordinate system of the view
   represented with the given key.
   
   - parameter absoluteValue: the Y coordinate in the absolute coordinate system
   - parameter key:           the key of the view that will be used to calculate the relative X coordinate
   
   - returns: the X coordinate in the `key` view coordinate system
   */
  func getYCoordinate(_ absoluteValue: CGFloat, inCoordinateSystemOfParentOfKey key: String) -> CGFloat
}
