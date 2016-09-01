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
  case list
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
                     update: @escaping (EmptyState)->(),
                     dispatch: StoreDispatch) -> [AnyNodeDescription] {
    
    return []
  }
  
  static func layout(views: ViewsContainer<AppKeys>, props: AppProps, state: EmptyState) {

  }
  
  static func connect(parentProps: AppProps, storageState: AppState) -> AppProps {
    return parentProps
  }
  

}

