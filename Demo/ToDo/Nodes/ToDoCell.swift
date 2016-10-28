//
//  ToDoCell.swift
//  Katana
//
//  Created by Luca Querella on 01/09/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana
import KatanaElements

struct ToDoCellProps: NodeProps {
  var frame = CGRect.zero
  var index = 0
  var name = ""
  var completed = false
  
  static func == (lhs: ToDoCellProps, rhs: ToDoCellProps) -> Bool {
    return lhs.frame == rhs.frame &&
      lhs.index == rhs.index &&
      lhs.name == rhs.name &&
      lhs.completed == rhs.completed
  }
  
  func index(_ index: Int) -> ToDoCellProps {
    var copy = self
    copy.index = index
    return copy
  }
}

enum ToDoCellKeys {
  case name, delete
}

struct ToDoCell: CellNodeDescription, ConnectedNodeDescription, PlasticNodeDescription {
  var props: ToDoCellProps
    
  static func childrenDescriptions(props: ToDoCellProps,
    state: EmptyHighlightableState,
    update: @escaping (EmptyHighlightableState) -> (),
    dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    
    let text = NSMutableAttributedString(string: props.name, attributes: [
      NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight),
      NSParagraphStyleAttributeName: paragraphStyle,
      NSForegroundColorAttributeName: UIColor.black,
      NSStrikethroughStyleAttributeName: props.completed
      ])
    
    return [
      Text(props: TextProps()
        .key(ToDoCellKeys.name)
        .text(text)
        .color(state.highlighted ? .gray : .white)
      ),
      
      Button(props: ButtonProps()
        .key(ToDoCellKeys.delete)
        .color(UIColor(0x1D9F9F))
        .text("-", fontSize: 10)
        .onTap({dispatch(RemoveTodo(payload: props.index))})
      )
    ]
  }
  
  public static func didTap(dispatch: StoreDispatch, props: ToDoCellProps, indexPath: IndexPath) {
    dispatch(ToogleTodoCompletion(payload: props.index))
  }
  
  static func layout(views: ViewsContainer<ToDoCellKeys>,
                     props: ToDoCellProps, state: EmptyHighlightableState) {
    
    let root = views.nativeView
    let name = views[.name]!
    let delete = views[.delete]!
    
    name.fill(root)
    
    delete.coverRight(name)
    delete.width = .scalable(60)
  }
  
  static func connect(props: inout ToDoCellProps, storageState: ToDoState) {
    
    if props.index < storageState.todos.count {
      props.name = storageState.todos[props.index]
      props.completed = storageState.todosCompleted[props.index]
    }

  }
}
