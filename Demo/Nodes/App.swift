//
//  App.swift
//  Katana
//
//  Created by Luca Querella on 10/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana

struct AppProps: Equatable, Frameable {
  enum Section {
    case Popup, Calculator, Tabbar
  }
  
  var section: Section
  var frame: CGRect
  
  static func ==(lhs: AppProps, rhs: AppProps) -> Bool {
    return lhs.section == rhs.section
  }
}

struct App : NodeDescription, ReferenceNodeDescription, PlasticNodeDescription, ConnectedNodeDescription {
  static var initialState = EmptyState()
  static var nativeViewType = UIView.self

  var props : AppProps
  
  static func referenceSize() -> CGSize {
    return CGSize(width: 640, height: 960)
  }
  
  static func render(props: AppProps,
                     state: EmptyState,
                     update: (EmptyState)->(),
                     dispatch: StoreDispatch) -> [AnyNodeDescription] {
    
    func onClose() {
      dispatch(HidePopup())
    }
    
    func onPasswordSet(_ password: [Int]) {
      dispatch(PinInserted(pin: [123]))
    }

    
    switch props.section {
    case .Popup:
      return [
        Calculator(props: CalculatorProps().key("calculator")),
        InstructionPopup(props: InstructionPopupProps()
          .key("popup")
          .onClose(onClose))
      ]
      
    case .Calculator:
      return [
        Calculator(props: CalculatorProps()
          .key("calculator")
          .onPasswordSet(onPasswordSet)),
      ]
      
    case .Tabbar:
      return [
        Tabbar(props: TabbarProps().key("tabbar"))
      ]
    }
  }
  
  static func layout(views: ViewsContainer,
                     props: AppProps,
                     state: EmptyState) -> Void {
    
    let root = views.rootView
    let popup = views["popup"]
    let tabbar = views["tabbar"]
    let calculator = views["calculator"]
    
    popup?.fill(root)
    calculator?.fill(root)
    tabbar?.fill(root)
  }
  
  
  static func connect(parentProps: AppProps, storageState: RootLogicState) -> AppProps {
    if storageState.showPopup {
      return AppProps(section: .Popup, frame: parentProps.frame)
    
    } else if storageState.password == nil {
      return AppProps(section: .Calculator, frame: parentProps.frame)
    
    } else {
      return AppProps(section: .Tabbar, frame: parentProps.frame)
    }
  }
}


