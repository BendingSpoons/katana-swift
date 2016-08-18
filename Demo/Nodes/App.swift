//
//  App.swift
//  Katana
//
//  Created by Luca Querella on 10/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana

struct AppState : Equatable {
  var showPopup = true
  var password : [Int]?
  
  static func ==(lhs: AppState, rhs: AppState) -> Bool {
    return lhs.showPopup == rhs.showPopup && lhs.password == rhs.password
  }
  
}

struct App : NodeDescription, ReferenceNodeDescription, PlasticNodeDescription {
  
  var props : EmptyProps
  var children: [AnyNodeDescription] = []
  
  static var initialState = AppState()
  static var viewType = UIView.self
  
  static func referenceSize() -> CGSize {
    return CGSize(width: 640, height: 960)
  }
  
  static func render(props: EmptyProps,
                     state: AppState,
                     children: [AnyNodeDescription],
                     update: (AppState)->()) -> [AnyNodeDescription] {
    
    
    print("render app \(state)")
    
    func onClose() {
      update(AppState(showPopup: false, password: state.password))
    }
    
    func onPasswordSet(_ password: [Int]) {
      update(AppState(showPopup: false, password: password))
    }
    
    
    if (state.showPopup) {
      return [
        Calculator(props: CalculatorProps().key("calculator"), children: []),
        InstructionPopup(props: InstructionPopupProps()
          .key("popup")
          .onClose(onClose), children: [])
      ]
      
    } else if (state.password == nil)  {
      return [
        Calculator(props: CalculatorProps()
          .key("calculator")
          .onPasswordSet(onPasswordSet), children: []),
      ]
    } else {
      
      return [
        Tabbar(props: TabbarProps().key("tabbar"))
      ]
    }
  }
  
  static func layout(views: ViewsContainer,
                     props: EmptyProps,
                     state: AppState) -> Void {
    
    let root = views.rootView
    let popup = views["popup"]
    let tabbar = views["tabbar"]
    let calculator = views["calculator"]
    
    popup?.fill(root)
    calculator?.fill(root)
    tabbar?.fill(root)
  }
}


