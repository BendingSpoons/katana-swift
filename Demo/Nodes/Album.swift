//
//  Album.swift
//  Katana
//
//  Created by Luca Querella on 15/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana

struct AlbumProps : Equatable,Frameable {
  var frame = CGRect.zero
  
  static func ==(lhs: AlbumProps, rhs: AlbumProps) -> Bool {
    return lhs.frame == rhs.frame
  }
}

struct AlbumState : Equatable {
  static func ==(lhs: AlbumState, rhs: AlbumState) -> Bool {
    return true
  }
}

struct Album : NodeDescription {
  var props : AlbumProps
  
  static var initialState = AlbumState()
  static var viewType = UIView.self
  
  static func render(props: AlbumProps,
                     state: AlbumState,
                     update: (AlbumState)->()) -> [AnyNodeDescription] {
    
    return [
      View(props: ViewProps().frame(props.frame.size).color(.yellow)),
      View(props: ViewProps().frame(0,0,320,45).color(.white)) {
        [
          Button(props: ButtonProps()
            .frame(10,20,30,20)
            .color(.black)
            .color(.gray, state: .highlighted)
          ),
          Button(props: ButtonProps()
            .frame(150,20,30,20)
            .color(.black)
            .color(.gray, state: .highlighted)
          ),
          Button(props: ButtonProps()
            .frame(270,20,30,20)
            .color(.black)
            .color(.gray, state: .highlighted)
          )
        ]
      }
    ]
  }
  
  init(props: AlbumProps) {
    self.props = props
  }
}
