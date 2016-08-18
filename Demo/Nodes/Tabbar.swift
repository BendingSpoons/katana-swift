//
//  Tabbar.swift
//  Katana
//
//  Created by Luca Querella on 15/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana

struct TabbarProps : Equatable,Frameable,Keyable {
  var frame = CGRect.zero
  var key: String?
  
  static func ==(lhs: TabbarProps, rhs: TabbarProps) -> Bool {
    return lhs.frame == rhs.frame
  }
  
}

struct TabbarState : Equatable {
  
  static func ==(lhs: TabbarState, rhs: TabbarState) -> Bool {
    return false
  }
  
}

struct Tabbar : NodeDescription {
  
  var props : TabbarProps
  var children: [AnyNodeDescription] = []
  
  static var initialState = TabbarState()
  static var viewType = UIView.self
  
  init(props: TabbarProps) {
    self.props = props
  }
  
  static func render(props: TabbarProps,
                     state: TabbarState,
                     children: [AnyNodeDescription],
                     update: (TabbarState)->()) -> [AnyNodeDescription] {
    
    
    struct Section {
      var color: UIColor
      var node: AnyNodeDescription
    }
    
    let sections = [
      Section(
        color: .red,
        node: View(props: ViewProps().color(.red))
      ),
      
      Section(
        color: .orange,
        node: View(props: ViewProps().color(.orange))
      ),
      
      Section(
        color: .green,
        node: View(props: ViewProps().color(.green))
      ),
      
      Section(
        color: .white,
        node: View(props: ViewProps().color(.white))
      ),
      
      Section(
        color: .purple,
        node: View(props: ViewProps().color(.purple))
      )
    ]
    
    return [
      View(props: ViewProps().key("viewContainer")/*.frame(0,0,320,435)*/.color(.blue)),
      View(props: ViewProps().key("tabbarContainer")/*.frame(0,435,320,45)*/.color(.black), children: sections.enumerated().map { (index,section) in
        
//        let width = props.frame.size.width/CGFloat(sections.count)
//        let frame = CGRect(x: width * CGFloat(index), y: 0, width: width, height: 45)
        
        return View(props: ViewProps().color(.black).key("tabbarButton-\(index)")/*.frame(frame)*/, children: [
          View(props: ViewProps().key("tabbarButtonImage-\(index)")/*.frame(10,10,width-20,45-20)*/.color(section.color))
          ])
        })
    ]
  }
  
  static func layout(views: PlasticViewsContainer, props: TabbarProps, state: TabbarState) -> Void {
    let root = views.rootView
    let viewContainer = views["viewContainer"]!
    let tabbarContainer = views["tabbarContainer"]!
    let buttons = views.orderedViews(withPrefix: "tabbarButton-", sortedBy: <)
    
    tabbarContainer.asFooter(root)
    tabbarContainer.height = .scalable(80)
    
    viewContainer.asHeader(root)
    viewContainer.bottom = tabbarContainer.top
    
    
    // buttons
    buttons.fill(left: tabbarContainer.left, right: tabbarContainer.right)
    
    for (index, btn) in buttons.enumerated() {
      btn.height = tabbarContainer.height
      btn.bottom = tabbarContainer.bottom
      
      // this is very ugly but in a real case scenario probably btn will be some self contained
      // view
      let image = views["tabbarButtonImage-\(index)"]!
      image.fill(btn, insets: .scalable(10, 10, 10 , 10))
    }
  }
}
