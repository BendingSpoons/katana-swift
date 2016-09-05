//
//  AppCell.swift
//  Katana
//
//  Created by Luca Querella on 01/09/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana

struct AppCellProps : NodeProps {
  var frame = CGRect.zero
  var index = 0
  var name = ""
  var completed = false
  
  static func ==(lhs: AppCellProps, rhs: AppCellProps) -> Bool {
    return lhs.frame == rhs.frame &&
      lhs.index == rhs.index &&
      lhs.name == rhs.name &&
      lhs.completed == rhs.completed
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

struct AppCell : CellNodeDescription, DispatchingNodeDescription, ConnectedNodeDescription, PlasticNodeDescription, PlasticNodeDescriptionWithReferenceSize {
  
  var props : AppCellProps
  
  //FIXME: this should not be necessery
  static var referenceSize: CGSize {
    return CGSize(width: 640, height: 960)
  }
    
  static func render(props: AppCellProps,
    state: EmptyHighlightableState,
    update: @escaping (EmptyHighlightableState) -> (),
    dispatch: StoreDispatch) -> [AnyNodeDescription] {
    
    let text = NSMutableAttributedString(string: props.name, attributes: [
      NSFontAttributeName : UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight),
      NSParagraphStyleAttributeName: NSParagraphStyle.centerAlignment,
      NSForegroundColorAttributeName : UIColor.black,
      NSStrikethroughStyleAttributeName : props.completed
      ])
    
    return [
      Text(props: TextProps()
        .key(AppCellKeys.name)
        .text(text)
        .color(state.highlighted ? .gray : .white)
      ),
      
      Button(props: ButtonProps()
        .key(AppCellKeys.delete)
        .color(0x1D9F9F)
        .text("-", fontSize: 10)
        .onTap({dispatch(RemoveTodo(payload: props.index))})
      )
    ]
  }
  
  public static func didTap(dispatch: StoreDispatch?, props: AppCellProps, indexPath: IndexPath) {
    dispatch?(ToogleTodoCompletion(payload: props.index))
  }
  
  static func layout(views: ViewsContainer<AppCellKeys>,
                     props: AppCellProps, state: EmptyHighlightableState) {
    
    let root = views.nativeView
    let name = views[.name]!
    let delete = views[.delete]!
    
    name.fill(root)
    
    delete.coverRight(name)
    delete.width = .scalable(60)
  }
  
  static func connect(props: inout AppCellProps, storageState: AppState) {
    
    //FIXME
    if props.index < storageState.todos.count   {
      props.name = storageState.todos[props.index]
      props.completed = storageState.todosCompleted[props.index]
    }

  }
}
