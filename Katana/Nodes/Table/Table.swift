//
//  Table.swift
//  Katana
//
//  Created by Mauro Bolis on 22/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

import UIKit

public struct TableProps: Equatable, Frameable, Keyable {
  public var frame = CGRect.zero
  public var key: String?
  public var delegate: TableDelegate?
  
  public init() {}
  
  public func delegate(_ delegate: TableDelegate) -> TableProps {
    var copy = self
    copy.delegate = delegate
    return copy
  }
  
  public static func ==(lhs: TableProps, rhs: TableProps) -> Bool {
    return lhs.key == rhs.key &&
      lhs.frame == rhs.frame
  }
}


public struct Table : NodeDescription {
  public var props : TableProps
  
  public static var initialState = EmptyState()
  public static var nativeViewType = KatanaTableView.self
  
  public init(props: TableProps) {
    self.props = props
  }
  
  public static func applyPropsToNativeView(props: TableProps,
                                            state: EmptyState,
                                            view: KatanaTableView,
                                            update: (EmptyState)->(),
                                            concreteNode: AnyNode)  {
    view.frame = props.frame
    
    if let delegate = props.delegate {
      view.update(withParentNode: concreteNode, delegate: delegate)
    }
  }
  
  
  public static func render(props: TableProps,
                            state: EmptyState,
                            update: (EmptyState)->(),
                            dispatch: StoreDispatch) -> [AnyNodeDescription] {
    return []
  }
}
