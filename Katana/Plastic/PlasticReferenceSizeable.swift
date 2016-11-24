//
//  PlasticReferenceSizeable.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import UIKit

/// Type Erasure for `PlasticReferenceSizeable`
public protocol AnyPlasticReferenceSizeable {
  static func anyReferenceSize(props: Any, state: Any) -> CGSize
}

/**
 Protocol that `NodeDescription` implementations can adopt to provide a reference size.
 
 Reference Size is used to calculate the Plastic multiplier. For a given node, the multiplier
 is calculated in the following way:
 
 - find the closest ancestor in the nodes tree
 
 - calculate the height multiplier: `ancestor.size.height / ancestor.description.referenceSize.height`
 
 - calculate the width multiplier: `ancestor.size.width / ancestor.description.referenceSize.width`
 
 - the Plastic multiplier is the minimum of the two
*/
public protocol PlasticReferenceSizeable: AnyPlasticReferenceSizeable, PlasticNodeDescription {
  /// the reference size of the `NodeDescription`
  static func referenceSize(props: PropsType, state: StateType) -> CGSize
}

public extension PlasticReferenceSizeable {
  static func anyReferenceSize(props: Any, state: Any) -> CGSize {
    if let p = props as? PropsType, let s = state as? StateType {
      return referenceSize(props: p, state: s)
    }
    return .zero
  }
}
