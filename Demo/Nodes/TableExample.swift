//
//  TableExample.swift
//  Katana
//
//  Created by Mauro Bolis on 22/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import Katana

private struct Delegate: TableDelegate {
  func numberOfRows(forSection section: Int) -> Int {
    return 200000
  }
  
  func height(forRowAt indexPath: IndexPath) -> Value {
    return .scalable(120)
  }
  
  private func nodeDescription(forRowAt indexPath: IndexPath) -> AnyNodeDescription {
    var props = CellExampleProps()
    props.additionalCounter = indexPath.row
    
    return CellExample(props: props)
  }
}

struct TableExample: NodeDescription {
  var props: EmptyProps
  
  static var initialState = EmptyState()
  static var nativeViewType = UIView.self
  
  static func render(props: EmptyProps,
                     state: EmptyState,
                     update: (EmptyState)->(),
                     dispatch: StoreDispatch) -> [AnyNodeDescription] {
    return [
      Table(props: TableProps()
        .frame(props.frame)
        .delegate(Delegate())
      )
    ]
  }
}
