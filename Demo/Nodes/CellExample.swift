//
//  CellExample.swift
//  Katana
//
//  Created by Mauro Bolis on 22/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import Katana

struct CellExampleProps: Frameable, Equatable {
  var frame = CGRect.zero
  var baseCounter = 0
  var additionalCounter = 0
  
  static func ==(lhs: CellExampleProps, rhs: CellExampleProps) -> Bool {
    return lhs.frame == rhs.frame &&
      lhs.baseCounter == rhs.baseCounter &&
      lhs.additionalCounter == rhs.additionalCounter
  }
}

struct CellExampleState: Highlightable, Equatable {
  var highlighted: Bool = false
  
  static func ==(lhs: CellExampleState, rhs: CellExampleState) -> Bool {
    return lhs.highlighted == rhs.highlighted
  }
}

struct CellExample: CellNodeDescription, ConnectedNodeDescription {
  var props: CellExampleProps
  
  static var initialState = CellExampleState()
  static var nativeViewType = CellNativeView.self
  
  static func render(props: CellExampleProps,
                     state: CellExampleState,
                     update: (CellExampleState)->(),
                     dispatch: StoreDispatch) -> [AnyNodeDescription] {
    
    let text = NSMutableAttributedString(string: "\(props.baseCounter + props.additionalCounter)", attributes: [
      NSFontAttributeName : UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight),
      NSParagraphStyleAttributeName: NSParagraphStyle.centerAlignment,
      NSForegroundColorAttributeName : UIColor.black
    ])
    
    return [
      View(props: ViewProps()
        .color(state.highlighted ? .red : .blue)
        .borderColor(state.highlighted ? .black : .red)
        .borderWidth(5)
        .frame(props.frame)) {
          [
            Text(props: TextProps()
              .frame(props.frame)
              .text(text)
              .color(UIColor.white.withAlphaComponent(0.6))
            )
          ]
      }
    ]
  }
  
  static func connect(parentProps: CellExampleProps, storageState: RootLogicState) -> CellExampleProps {
    var newProps = parentProps
    newProps.baseCounter = storageState.counter
    return newProps
  }
  
  static func didTap(dispatch: StoreDispatch, props: CellExampleProps, indexPath: IndexPath) {
    dispatch(IncreaseCounter())
  }
}
