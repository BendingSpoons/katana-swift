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
  let props: TableExampleProps
  
  func numberOfRows(forSection section: Int) -> Int {
    return 200//000
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

struct TableExampleProps: Frameable, Equatable, Keyable {
  var counter: Int = 0
  var frame = CGRect.zero
  var key: String?
  
  static func ==(l: TableExampleProps, r: TableExampleProps) -> Bool {
    return l.counter == r.counter && l.frame == r.frame
  }
}

struct TableExample: NodeDescription, ConnectedNodeDescription {
  var props: TableExampleProps
  
  static var initialState = EmptyState()
  static var nativeViewType = UIView.self
  
  static func render(props: TableExampleProps,
                     state: EmptyState,
                     update: (EmptyState)->(),
                     dispatch: StoreDispatch) -> [AnyNodeDescription] {
    
    var tableProps = TableProps().frame(props.frame)
    
    if (props.counter < 10) {
      tableProps = tableProps.delegate(Delegate(props: props))
    }
    
    
    return [
      Table(props: tableProps)
    ]
  }
  
  static func connect(parentProps: TableExampleProps, storageState: RootLogicState) -> TableExampleProps {
    var newProps = parentProps
    newProps.counter = storageState.counter
    
    return newProps
  }
}
