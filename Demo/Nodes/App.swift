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

struct App : NodeDescription, ConnectedNodeDescription, PlasticNodeDescription, PlasticNodeDescriptionWithReferenceSize  {
  
  typealias NativeView = UIView
  
  
  static var initialState = EmptyState()
  static var nativeViewType = UIView.self
  
  var props : AppProps
  
  static var referenceSize: CGSize {
    return CGSize(width: 640, height: 960)
  }
  
  static func render(props: AppProps,
                     state: EmptyState,
                     update: (EmptyState)->(),
                     dispatch: StoreDispatch) -> [AnyNodeDescription] {
    
    
    if (props.showCalculator) {
      return [
        Calculator(props: CalculatorProps()
          .onPasswordSet({ dispatch(SetPin(payload: $0)) })
          .key(AppKeys.calculator)
        ),
/*        InstructionPopup(props: InstructionPopupProps()
         // .onClose({ dispatch(DismissInstructionsAction.with(payload: true)) })
          .key(AppKeys.popup)
        )*/
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
    
    if (!props.showPopup) {
      popup?.bottom = root.top
    }
  }
  
  static func connect(parentProps: AppProps, storageState: AppState) -> AppProps {
    var parentProps = parentProps
    parentProps.showPopup = !storageState.instructionShown
    parentProps.showCalculator = storageState.pin == nil
    return parentProps
  }
  
  static func childrenAnimationForNextRender(currentProps: AppProps,
                                             nextProps: AppProps,
                                             currentState: EmptyState,
                                             nextState: EmptyState,
                                             parentAnimation: Animation) -> Animation {
    
    return .simpleSpring(duration: 1, damping: 0.3, initialVelocity: 1)
    
  }
  
  
}

