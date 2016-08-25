//
//  PlasticNode.swift
//  Katana
//
//  Created by Mauro Bolis on 19/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

// A node that is able to provide a plastic multiplier
public protocol PlasticMultiplierProvider {
  func getPlasticMultiplier() -> CGFloat
}

// A node that is able to leverage plastic to trigger the layout of the nodes 
// returned from the NodeDescription
protocol NodeWithPlastic: PlasticMultiplierProvider {
  associatedtype Description: PlasticNodeDescription
  func applyLayout(to children: [AnyNodeDescription], description: Description) -> [AnyNodeDescription]
}
