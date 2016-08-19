//
//  ReferenceViewProvider.swift
//  Katana
//
//  Created by Mauro Bolis on 18/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public protocol ReferenceViewProvider {
  func getPlasticMultiplier() -> CGFloat
}

public protocol ReferenceNodeDescription {
  static func referenceSize() -> CGSize
}


public protocol AnyPlasticNodeDescription {
  static func _layout(views: ViewsContainer, props: Any, state: Any) -> Void
}

public protocol PlasticNodeDescription: AnyPlasticNodeDescription {
  associatedtype Props
  associatedtype State
  static func layout(views: ViewsContainer, props: Props, state: State) -> Void
}

public extension PlasticNodeDescription {
  static func _layout(views: ViewsContainer, props: Any, state: Any) -> Void {
    if let p = props as? Props, let s = state as? State {
      layout(views: views, props: p, state: s)
    }
  }
}
