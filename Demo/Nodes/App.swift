//
//  App.swift
//  Katana
//
//  Created by Luca Querella on 25/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana

struct AppProps: Equatable, Frameable {
  var showPopup = false
  var showCalculator = false
  var frame: CGRect = CGRect.zero
  var todos: [String] = []
  
  static func ==(lhs: AppProps, rhs: AppProps) -> Bool {
    return lhs.showPopup == rhs.showPopup &&
      lhs.showCalculator == rhs.showCalculator &&
      lhs.frame == rhs.frame &&
      lhs.todos == rhs.todos
  }
}

enum AppKeys: String,NodeDescriptionKeys {
  case title, add, list
}

struct App : NodeDescription, ConnectedNodeDescription, PlasticNodeDescription, PlasticNodeDescriptionWithReferenceSize  {
  
  typealias NativeView = UIView
  
  
  static var initialState = EmptyState()
  static var nativeViewType = UIView.self
  
  var props : AppProps
  
  static var referenceSize: CGSize {
    return CGSize(width: 640, height: 960)
  }
  
  static func render(props: AppProps,
                     state: EmptyState,
                     update: @escaping  (EmptyState) -> (),
                     dispatch: StoreDispatch) -> [AnyNodeDescription] {
    
    
    func addTodo() {
      let randomNumber = Int(arc4random_uniform(1000) + 1)
      dispatch(AddTodo(payload: "My todo \(randomNumber)"))
    }
    
    return [
      Text(props: TextProps().text("My awesome todos", fontSize: 10).color(.red).key(AppKeys.title)),
      Button(props: ButtonProps().color(.blue).key(AppKeys.add).text("+", fontSize: 10).onTap(addTodo)),
      Table(props: TableProps().key(AppKeys.list).delegate(AppListDelegate(todos: props.todos )))
    ]
    
  }
  
  static func layout(views: ViewsContainer<AppKeys>, props: AppProps, state: EmptyState) {
    
    let root = views.nativeView
    let title = views[.title]!
    let add = views[.add]!
    let list = views[.list]!
    
    title.asHeader(root, insets: .scalable(30, 0, 0, 0))
    title.height = .scalable(60)
    
    add.coverRight(title)
    add.width = .scalable(60)
    
    list.fillHorizontally(root)
    list.top = title.bottom
    list.bottom = root.bottom
  }
  
  static func connect(props: inout AppProps, storageState: AppState){
    props.todos = storageState.todos
  }
}

struct AppListDelegate  : TableDelegate {
  var todos: [String]
  
  func numberOfSections() -> Int {
    return 1
  }
  
  func numberOfRows(forSection section: Int) -> Int {
    return todos.count
  }
  
  func nodeDescription(forRowAt indexPath: IndexPath) -> AnyNodeDescription {
    return AppCell(props: AppCellProps().index(indexPath.item))
  }
  
  func height(forRowAt indexPath: IndexPath) -> Value {
    return .fixed(50)
  }
}

