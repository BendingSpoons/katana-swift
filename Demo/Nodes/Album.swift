//
//  Album.swift
//  Katana
//
//  Created by Luca Querella on 15/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana
import UIKit

struct AlbumProps : Equatable,Frameable, Keyable {
  var frame = CGRect.zero
  var key: String?
  
  static func ==(lhs: AlbumProps, rhs: AlbumProps) -> Bool {
    return lhs.frame == rhs.frame
  }
}

struct AlbumState : Equatable {
  static func ==(lhs: AlbumState, rhs: AlbumState) -> Bool {
    return true
  }
}

struct Album : NodeDescription, PlasticNodeDescription {
  var props : AlbumProps
  
  static var initialState = AlbumState()
  static var nativeViewType = UIView.self
  
  static func render(props: AlbumProps,
                     state: AlbumState,
                     update: (AlbumState)->(),
                     dispatch: StoreDispatch) -> [AnyNodeDescription] {
    
    return [
      View(props: ViewProps().key("fullView").color(.yellow)),
      View(props: ViewProps().key("buttonsContainer").color(.white)) {
        [
          Button(props: ButtonProps()
            .key("leftButton")
            .color(.black)
            .color(.gray, state: .highlighted)
          ),
          Button(props: ButtonProps()
            .key("centerButton")
            .color(.black)
            .color(.gray, state: .highlighted)
          ),
          Button(props: ButtonProps()
            .key("rightButton")
            .color(.black)
            .color(.gray, state: .highlighted)
          )
        ]
      }
    ]
  }
  
  static func layout(views: ViewsContainer, props: AlbumProps, state: AlbumState) -> Void {
    let buttonsContainer = views["buttonsContainer"]!
    let fullView = views["fullView"]!
    let leftButton = views["leftButton"]!
    let centerButton = views["centerButton"]!
    let rightButton = views["rightButton"]!
    let root = views.rootView
    
    fullView.fill(root)
    
    buttonsContainer.asHeader(root)
    buttonsContainer.height = .scalable(90)
    
    leftButton.size = .scalable(60, 40)
    leftButton.setCenterY(buttonsContainer.centerY, .fixed(10))
    leftButton.setLeft(buttonsContainer.left, .scalable(10))
    
    rightButton.size = .scalable(60, 40)
    rightButton.setCenterY(buttonsContainer.centerY, .fixed(10))
    rightButton.setRight(buttonsContainer.right, .scalable(-10))
    
    centerButton.size = .scalable(60, 40)
    centerButton.setCenterY(buttonsContainer.centerY, .fixed(10))
    centerButton.center(betweenLeft: leftButton.right, andRight: rightButton.left)
  }
}
