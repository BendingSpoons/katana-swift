//
//  MineField.swift
//  Katana
//
//  Created by Luca Querella on 25/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana
import KatanaElements


struct MineFieldProps: NodeProps {
  var frame: CGRect = CGRect.zero
  var gameover: Bool = false
  
  static func == (lhs: MineFieldProps, rhs: MineFieldProps) -> Bool {
    return
      lhs.frame == rhs.frame && lhs.gameover == rhs.gameover
  }
}

enum MineFieldKeys {
  case title, field
}

struct MineField: NodeDescription, ConnectedNodeDescription, PlasticNodeDescription, PlasticNodeDescriptionWithReferenceSize {
  
  var props: MineFieldProps
  
  static var referenceSize: CGSize {
    return CGSize(width: 640, height: 960)
  }
  
  static func childrenDescriptions(props: MineFieldProps,
                     state: EmptyState,
                     update: @escaping  (EmptyState) -> (),
                     dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    
    
    func startGame() {
      dispatch(StartGame(payload: .hard))
    }
    
    
    let text = props.gameover ? ":(" : ":)"
    
    return [
      Button(props: ButtonProps()
        .key(MineFieldKeys.title)
        .text(text, fontSize: 15)
        .borderColor(UIColor(0xC42900))
        .borderWidth(2)
        .onTap(startGame)
      ),
      MineFieldGrid(props: MineFieldGridProps()
        .key(MineFieldKeys.field)
      )
      
    ]
    
  }
  
  static func layout(views: ViewsContainer<MineFieldKeys>, props: MineFieldProps, state: EmptyState) {
    
    let root = views.nativeView
    let title = views[.title]!
    let field = views[.field]!
    
    title.asHeader(root, insets: .scalable(30, 0, 0, 0))
    title.height = .scalable(60)
    
    field.fillHorizontally(root)
    field.top = title.bottom
    field.bottom = root.bottom
  }
  
  static func connect(props: inout MineFieldProps, to storeState: MineFieldState) {
    props.gameover = storeState.gameOver
  }
}
