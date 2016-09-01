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
      lhs.index == rhs.index
  }
  
  func index(_ index: Int) -> AppCellProps {
    var copy = self
    copy.index = index
    return copy
  }

}

enum AppCellKeys: String,NodeDescriptionKeys {
  case name
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
      Text(props: TextProps().text(props.name, fontSize: 7).key(AppCellKeys.name))
    ]
  }
  
  static func layout(views: ViewsContainer<AppCellKeys>, props: AppCellProps, state: EmptyState) {
    let root = views.rootView
    let name = views[.name]!
    
    name.fill(root)
  }
  
  static func connect(props: inout AppCellProps, storageState: AppState) {
    props.name = storageState.todos[props.index]
  }
}
