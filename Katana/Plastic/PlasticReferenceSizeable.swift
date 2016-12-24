//
//  PlasticReferenceSizeable.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import CoreGraphics
/**
 Protocol that `NodeDescription` implementations can adopt to provide a reference size.
 
 Reference Size is used to calculate the Plastic multiplier. For a given node, the multiplier
 is calculated in the following way:
 
 - find the closest ancestor in the nodes tree
 
 - calculate the height multiplier: `ancestor.size.height / ancestor.description.referenceSize.height`
 
 - calculate the width multiplier: `ancestor.size.width / ancestor.description.referenceSize.width`
 
 - the Plastic multiplier is the minimum of the two
*/
public protocol PlasticReferenceSizeable {

  /// the reference size of the `NodeDescription`
  static var referenceSize: CGSize { get }
}
