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
