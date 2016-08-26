//
//  App.swift
//  Katana
//
//  Created by Luca Querella on 25/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana

struct AppProps: Equatable, Frameable {
  var showPopup = false
  var showCalculator = false
  var frame: CGRect = CGRect.zero
  
  static func ==(lhs: AppProps, rhs: AppProps) -> Bool {
    return lhs.showPopup == rhs.showPopup &&
      lhs.showCalculator == rhs.showCalculator &&
      lhs.frame == rhs.frame
  }
}

enum AppKeys: String,NodeDescriptionKeys {
  case calculator, popup
}

struct App : NodeDescription, ConnectedNodeDescription, PlasticNodeDescription, PlasticReferenceSizeNodeDescription  {
  
  typealias NativeView = UIView
  
  
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
    
    
    if (props.showPopup) {
      return [
        Calculator(props: CalculatorProps().key(AppKeys.calculator)),
        InstructionPopup(props: InstructionPopupProps()
          .onClose({ dispatch(AppStateActions.DismissInstructionsAction.with(payload: true)) })
          .key(AppKeys.popup))
      ]
    } else if (props.showCalculator) {
      return [
        Calculator(props: CalculatorProps()
          .onPasswordSet({ dispatch(AppStateActions.SetPinAction.with(payload: $0)) })
          .key(AppKeys.calculator)),
      ]
    } else {
      return [
        View(props: ViewProps())
      ]
    }
    
    
  }
  
  static func layout(views: ViewsContainer<AppKeys>, props: AppProps, state: EmptyState) {
    let root = views.rootView
    let popup = views[.popup]
    let calculator = views[.calculator]
    
    popup?.fill(root)
    calculator?.fill(root)
  }
  
  static func connect(parentProps: AppProps, storageState: AppState) -> AppProps {
    var parentProps = parentProps
    parentProps.showPopup = !storageState.instructionShown
    parentProps.showCalculator = storageState.pin == nil
    return parentProps
  }
  
}

