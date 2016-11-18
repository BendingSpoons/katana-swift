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
    view.alpha = props.alpha
    
    guard let url = props.url, url != view.url  else {
        return
    }
    
    view.load(URLRequest(url: url))
  }
}

extension WebView {
  enum ChildrenKeys {
  }
  
  struct Props: NodeDescriptionProps, Buildable, Equatable {
    var frame: CGRect = .zero
    var key: String?
    var alpha: CGFloat = 1.0
    var url: URL?
    
    public static func == (lhs: Props, rhs: Props) -> Bool {
      return lhs.frame == rhs.frame
        && lhs.key == rhs.key
        && lhs.alpha == rhs.alpha
        && lhs.url == rhs.url
    }
  }
}
