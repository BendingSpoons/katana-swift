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

 If you need to return a simple value that doesn't depend on props and state, adopt `PlasticReferenceSizeable`
 and just define the `referenceSize` static var.

  - seeAlso: `PlasticReferenceSizeable`
*/
public protocol PlasticExtendedReferenceSizeable: AnyPlasticReferenceSizeable, PlasticNodeDescription {
  /// the reference size of the `NodeDescription`
  static func referenceSize(props: PropsType, state: StateType) -> CGSize
}

/**
 Protocol that `NodeDescription` implementations can adopt to provide a reference size.
 If you want to return different values depending on props/state, you can adopt the `PlasticExtendedReferenceSizeable` protocol.

 Reference Size is used to calculate the Plastic multiplier. For a given node, the multiplier
 is calculated in the following way:

 - find the closest ancestor in the nodes tree

 - calculate the height multiplier: `ancestor.size.height / ancestor.description.referenceSize.height`

 - calculate the width multiplier: `ancestor.size.width / ancestor.description.referenceSize.width`

 - the Plastic multiplier is the minimum of the two

 - seeAlso: `PlasticExtendedReferenceSizeable`
*/
public protocol PlasticReferenceSizeable: PlasticExtendedReferenceSizeable {
  /// The referenceSize of the `NodeDescription`
  static var referenceSize: CGSize { get }
}

public extension PlasticExtendedReferenceSizeable {
  /**
   Implementation of the `PlasticExtendedReferenceSizeable` protocol.

   - seeAlso: `PlasticExtendedReferenceSizeable`
  */
  static func anyReferenceSize(props: Any, state: Any) -> CGSize {
    let p = props as! PropsType, s = state as! StateType
    return referenceSize(props: p, state: s)
  }
}

public extension PlasticReferenceSizeable {
  /**
   Implementation of the `PlasticReferenceSizeable` protocol.

   - seeAlso: `PlasticReferenceSizeable`
  */
  static func referenceSize(props: PropsType, state: StateType) -> CGSize {
    return referenceSize
  }
}
