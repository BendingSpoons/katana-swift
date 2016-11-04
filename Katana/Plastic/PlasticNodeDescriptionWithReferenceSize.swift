//
//  PlasticNodeDescriptionWithReferenceSize.swift
//  Katana
//
//  Created by Mauro Bolis on 19/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

/**
 Protocol that `NodeDescription` implementations can adopt to provide a reference size.
 
 Reference Size is used to calculate the Plastic multiplier. For a given node, the multiplier
 is calculated in the following way:
 
 - find the closest anchestor in the nodes tree
 
 - calculate the height multiplier: `anchestor.size.height / anchestor.desription.referenceSize.height`
 
 - calculate the width multiplier: `anchestor.size.width / anchestor.desription.referenceSize.width`
 
 - the plastic multiplier is the minimum of the two
*/
public protocol PlasticNodeDescriptionWithReferenceSize {
  
  /// the reference size of the `NodeDescription`
  static var referenceSize: CGSize {get}
}
