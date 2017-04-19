//
//  Table.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import UIKit
import Katana

public extension Table {
  public struct Props: NodeDescriptionProps, NodeDescriptionWithRefProps, Buildable {
    public var frame = CGRect.zero
    public var key: String?
    public var alpha: CGFloat = 1.0

    public var delegate: TableDelegate = EmptyTableDelegate()
    public var backgroundColor = UIColor.white
    public var cornerRadius: CGFloat = 0.0
    public var borderWidth: CGFloat = 0.0
    public var borderColor = UIColor.clear
    public var clipsToBounds = true
    public var refCallback: RefCallbackClosure<TableRef>?

    public init() {}

    public static func == (lhs: Props, rhs: Props) -> Bool {
      return
        lhs.frame == rhs.frame &&
          lhs.key == rhs.key &&
          lhs.alpha == rhs.alpha &&
          lhs.backgroundColor == rhs.backgroundColor &&
          lhs.cornerRadius == rhs.cornerRadius &&
          lhs.borderWidth == rhs.borderWidth &&
          lhs.borderColor == rhs.borderColor &&
          lhs.clipsToBounds == rhs.clipsToBounds &&
          lhs.delegate.isEqual(to: rhs.delegate)
    }
  }
}

public struct Table: NodeDescription, NodeDescriptionWithRef {
  public typealias NativeView = NativeTable

  public var props: Props
  
  public init(props: Props) {
    self.props = props
  }

  public static func applyPropsToNativeView(props: Props,
                                            state: EmptyState,
                                            view: NativeTable,
                                            update: @escaping (EmptyState)->(),
                                            node: AnyNode) {

    view.frame = props.frame
    view.alpha = props.alpha
    view.backgroundColor = props.backgroundColor
    view.layer.cornerRadius = props.cornerRadius
    view.layer.borderWidth = props.borderWidth
    view.layer.borderColor = props.borderColor.cgColor
    view.clipsToBounds = props.clipsToBounds
    view.update(withparent: node, delegate: props.delegate)
  }

  public static func childrenDescriptions(props: Props,
                            state: EmptyState,
                            update: @escaping (EmptyState)->(),
                            dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    return []
  }
}
