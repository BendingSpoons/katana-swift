//
//  ToDo.swift
//  Katana
//
//  Created by Luca Querella on 25/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana
import KatanaElements

struct ToDoProps: NodeProps {
  var showPopup = false
  var showCalculator = false
  var frame: CGRect = CGRect.zero
  var todos: [String] = []
  
  static func == (lhs: ToDoProps, rhs: ToDoProps) -> Bool {
    
    return lhs.showPopup == rhs.showPopup &&
      lhs.showCalculator == rhs.showCalculator &&
      lhs.frame == rhs.frame &&
      lhs.todos == rhs.todos
  }
}

enum ToDoKeys {
  case title, add, list
}

struct ToDo: NodeDescription, ConnectedNodeDescription, PlasticNodeDescription, PlasticNodeDescriptionWithReferenceSize {
  
  var props: ToDoProps
  
  static var referenceSize: CGSize {
    return CGSize(width: 640, height: 960)
  }
  
  
  static func render(props: ToDoProps,
                     state: EmptyState,
                     update: @escaping (EmptyState) -> (),
                     dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
        
    
    func addTodo() {
      let randomNumber = Int(arc4random_uniform(1000) + 1)
      dispatch(AddTodo(payload: "My todo \(randomNumber)"))
    }
    
    return [
      Text(props: TextProps()
        .key(ToDoKeys.title)
        .text("My awesome todos", fontSize: 15)
        .borderColor(UIColor(0xC42900))
        .borderWidth(2)
      ),
      
      Button(props: ButtonProps()
        .key(ToDoKeys.add)
        .color(0xEE6502)
        .color(UIColor(0xC42900), state: .highlighted)
        .text("+", fontSize: 10)
        .onTap(addTodo)
      ),
      
      Table(props: TableProps()
        .key(ToDoKeys.list)
        .delegate(ToDoListDelegate(todos: props.todos ))
      )
    ]
    
  }
  
  static func layout(views: ViewsContainer<ToDoKeys>, props: ToDoProps, state: EmptyState) {
    
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
  
  static func connect(props: inout ToDoProps, storageState: ToDoState) {
    props.todos = storageState.todos
  }
}

struct ToDoListDelegate: TableDelegate {
  var todos: [String]
  
  func numberOfSections() -> Int {
    return 1
  }
  
  func numberOfRows(forSection section: Int) -> Int {
    return todos.count
  }
  
  func nodeDescription(forRowAt indexPath: IndexPath) -> AnyNodeDescription {
    return ToDoCell(props: ToDoCellProps().index(indexPath.item))
  }
  
  func height(forRowAt indexPath: IndexPath) -> Value {
    return .scalable(100)
  }
}
