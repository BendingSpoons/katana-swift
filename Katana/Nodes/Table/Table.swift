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
    // delegate to the table mechanism any optimization here
    return false
  }
}


public struct Table : NodeDescription {
  public var props : TableProps
  
  public static var initialState = EmptyState()
  public static var nativeViewType = NativeTableView.self
  
  public init(props: TableProps) {
    self.props = props
  }
  

  public static func applyPropsToNativeView(props: TableProps,
                                            state: EmptyState,
                                            view: NativeTableView,
                                            update: (EmptyState)->(),
                                            concreteNode: AnyNode)  {
    
    let delegate = props.delegate ?? EmptyTableDelegate()
    view.frame = props.frame
    view.update(withParentNode: concreteNode, delegate: delegate)
  }
  
  
  public static func render(props: TableProps,
                            state: EmptyState,
                            update: (EmptyState)->(),
                            dispatch: StoreDispatch) -> [AnyNodeDescription] {
    return []
  }
}
