//
//  WebView.swift
//  HackerNewsClient
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import WebKit
import Katana
import KatanaElements

struct WebView: NodeDescription {
  typealias PropsType = Props
  typealias StateType = EmptyState
  typealias NativeView = WKWebView
  typealias Keys = ChildrenKeys
  
  var props: PropsType
  
  static func childrenDescriptions(props: PropsType,
                                   state: StateType,
                                   update: @escaping (StateType) -> (),
                                   dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
      
    return []
  }
  
  static func applyPropsToNativeView(props: PropsType,
                                     state: StateType,
                                     view: NativeView,
                                     update: @escaping (StateType)->(),
                                     node: AnyNode) {
    view.frame = props.frame
    
    if let url = props.url {
      view.load(URLRequest(url: url))
    }
  }
}

extension WebView {
  enum ChildrenKeys {
  }
  
  struct Props: NodeDescriptionProps, Buildable {
      var frame: CGRect = .zero
      var key: String?
      var alpha: CGFloat = 1.0
      var url: URL?
  }
}
