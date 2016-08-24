//
//  PasticReferenceSizeNodeDescription.swift
//  Katana
//
//  Created by Mauro Bolis on 19/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

// type erasure for PlasticNodeDescription
public protocol AnyPlasticNodeDescription {
  static func anyLayout(views: ViewsContainer, props: Any, state: Any) -> Void
}

// a node that has a reference size
public protocol PasticReferenceSizeNodeDescription {
  static func referenceSize() -> CGSize
}
