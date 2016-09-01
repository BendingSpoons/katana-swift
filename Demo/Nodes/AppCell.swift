//
//  AppCell.swift
//  Katana
//
//  Created by Luca Querella on 01/09/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana

struct AppCellProps : Equatable,Frameable {
  var frame = CGRect.zero
  var index = 0
  var name = ""
  
  static func ==(lhs: AppCellProps, rhs: AppCellProps) -> Bool {
    return lhs.frame == rhs.frame &&
      lhs.index == rhs.index &&
      lhs.name == rhs.name
  }
  
  func index(_ index: Int) -> AppCellProps {
    var copy = self
    copy.index = index
    return copy
  }
}

enum AppCellKeys: String,NodeDescriptionKeys {
  case name, delete
}

struct AppCell : NodeDescription, ConnectedNodeDescription, PlasticNodeDescription {
  
  typealias NativeView = UIView
  
  var props : AppCellProps
  static var initialState = EmptyState()
  
  init(props: AppCellProps) {
    self.props = props
  }
  
  static func render(props: AppCellProps,
    state: EmptyState,
    update: @escaping (EmptyState) -> (),
    dispatch: StoreDispatch) -> [AnyNodeDescription] {
    
    
    return [
      Text(props: TextProps()
        .key(AppCellKeys.name)
        .text(props.name, fontSize: 7)
      ),
      
      Button(props: ButtonProps()
        .key(AppCellKeys.delete)
        .color(.orange)
        .text("-", fontSize: 10)
        .onTap({dispatch(RemoveTodo(payload: props.index))})
      )
    ]
  }
  
  static func layout(views: ViewsContainer<AppCellKeys>,
                     props: AppCellProps, state: EmptyState) {
    
    let root = views.nativeView
    let name = views[.name]!
    let delete = views[.delete]!
    
    name.fill(root)
    
    delete.coverRight(name)
    delete.width = .fixed(30)
  }
  
  static func connect(props: inout AppCellProps, storageState: AppState) {
    props.name = storageState.todos[props.index]
  }
}
