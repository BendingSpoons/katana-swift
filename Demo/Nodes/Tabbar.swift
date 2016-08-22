//
//  Tabbar.swift
//  Katana
//
//  Created by Luca Querella on 15/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana
import UIKit

struct TabbarProps : Equatable,Frameable,Keyable {
  var frame = CGRect.zero
  var key: String?
  
  static func ==(lhs: TabbarProps, rhs: TabbarProps) -> Bool {
    return lhs.frame == rhs.frame
  }
}

struct TabbarState : Equatable {
  var section : Int
  
  static func ==(lhs: TabbarState, rhs: TabbarState) -> Bool {
    return lhs.section == rhs.section
  }
}

private struct Section {
  var color: UIColor
  var node: AnyNodeDescription
}

struct Tabbar : NodeDescription, PlasticNodeDescription {
  static var initialState = TabbarState(section: 0)
  static var nativeViewType = UIView.self

  var props : TabbarProps
  
  init(props: TabbarProps) {
    self.props = props
  }

  static func render(props: TabbarProps,
                     state: TabbarState,
                     update: (TabbarState)->(),
                     dispatch: StoreDispatch) -> [AnyNodeDescription] {
    let sections = [
      Section(
        color: .red,
        node: Album(props: AlbumProps().key("view"))
      ),
      
      Section(
        color: .orange,
        node: View(props: ViewProps()
          .key("view")
          .color(.orange))
      ),
      
      Section(
        color: .green,
        node: View(props: ViewProps()
          .key("view")
          .color(.green))
      ),
      
      Section(
        color: .white,
        node: View(props: ViewProps()
          .key("view")
          .color(.white))
      ),
      
      Section(
        color: .purple,
        node: View(props: ViewProps()
          .key("view")
          .color(.purple))
      )
    ]
    
    return [
      sections[state.section].node,
      
      View(props: ViewProps().key("tabbarContainer").color(.black)) {
        return sections.enumerated().map { (index,section) in
          return View(props: ViewProps().color(.black).key("tabbarButtonContainer-\(index)")) {
            [
              Button(props: ButtonProps()
                .key("tabbarButton-\(index)")
                .color(section.color)
                .onTap { update(TabbarState(section: index)) })
            ]
          }
        }
      }
    ]
  }
  
  static func layout(views: ViewsContainer, props: TabbarProps, state: TabbarState) -> Void {
    let root = views.rootView
    let view = views["view"]!
    let tabbarContainer = views["tabbarContainer"]!
    let buttons = views.orderedViews(withPrefix: "tabbarButtonContainer-", sortedBy: <)
    
    tabbarContainer.asFooter(root)
    tabbarContainer.height = .scalable(80)
    
    view.asHeader(root)
    view.bottom = tabbarContainer.top
    
    
    // buttons
    buttons.fill(left: tabbarContainer.left, right: tabbarContainer.right)
    
    for (index, btn) in buttons.enumerated() {
      btn.height = tabbarContainer.height
      btn.bottom = tabbarContainer.bottom
      
      // this is very ugly but in a real case scenario probably btn will be some self contained
      // view
      let image = views["tabbarButton-\(index)"]!
      image.fill(btn, insets: .scalable(10, 10, 10 , 10))
    }
  }
}
