//
//  CellExample.swift
//  Katana
//
//  Created by Mauro Bolis on 22/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import Katana

struct CellExaple: NodeDescription {
  var props: EmptyProps
  
  static var initialState = EmptyState()
  static var nativeViewType = UIView.self
  
  static func render(props: EmptyProps,
                     state: EmptyState,
                     update: (EmptyState)->(),
                     dispatch: StoreDispatch) -> [AnyNodeDescription] {
    return [
      View(props: ViewProps()
        .color(.blue)
        .borderColor(.red)
        .borderWidth(5)
        .frame(props.frame)
      )
    ]
  }
}
