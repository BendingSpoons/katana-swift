//
//  GridExample.swift
//  Katana
//
//  Created by Mauro Bolis on 23/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import Katana

private struct Delegate: GridDelegate {
  let props: GridExampleProps
  
  func numberOfRows(forSection section: Int) -> Int {
    return 200//000
  }
  
  private func nodeDescription(forRowAt indexPath: IndexPath) -> AnyNodeDescription {
    var props = CellExampleProps()
    props.additionalCounter = indexPath.row
    
    return CellExample(props: props)
  }
}

struct GridExampleProps: Frameable, Equatable, Keyable {
  var counter: Int = 0
  var frame = CGRect.zero
  var key: String?
  
  static func ==(l: GridExampleProps, r: GridExampleProps) -> Bool {
    return l.counter == r.counter && l.frame == r.frame
  }
}

struct GridExample: NodeDescription, ConnectedNodeDescription {
  var props: GridExampleProps
  
  static var initialState = EmptyState()
  static var nativeViewType = UIView.self
  
  static func render(props: GridExampleProps,
                     state: EmptyState,
                     update: (EmptyState)->(),
                     dispatch: StoreDispatch) -> [AnyNodeDescription] {
    
    var tableProps = GridProps().frame(props.frame)
    
    if (props.counter < 10) {
      tableProps = tableProps.delegate(Delegate(props: props))
    }
    
    
    return [
      Grid(props: tableProps)
    ]
  }
  
  static func connect(parentProps: GridExampleProps, storageState: RootLogicState) -> GridExampleProps {
    var newProps = parentProps
    newProps.counter = storageState.counter
    
    return newProps
  }
}