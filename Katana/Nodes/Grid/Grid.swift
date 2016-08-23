//
//  Grid.swift
//  Katana
//
//  Created by Mauro Bolis on 23/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import UIKit

public struct GridProps: Equatable, Frameable, Keyable {
  public var frame = CGRect.zero
  public var key: String?
  public var delegate: GridDelegate?
  
  public init() {}
  
  public func delegate(_ delegate: GridDelegate) -> GridProps {
    var copy = self
    copy.delegate = delegate
    return copy
  }
  
  public static func ==(lhs: GridProps, rhs: GridProps) -> Bool {
    // delegate to the grid mechanism any optimization here
    return false
  }
}


public struct Grid : NodeDescription {
  public var props : GridProps
  
  public static var initialState = EmptyState()
  public static var nativeViewType = NativeGridView.self
  
  public init(props: GridProps) {
    self.props = props
  }
  
  public static func applyPropsToNativeView(props: GridProps,
                                            state: EmptyState,
                                            view: NativeGridView,
                                            update: (EmptyState)->(),
                                            concreteNode: AnyNode)  {
    
    let delegate = props.delegate ?? EmptyGridDelegate()
    view.frame = props.frame
    view.update(withParentNode: concreteNode, delegate: delegate)
  }
  
  
  public static func render(props: GridProps,
                            state: EmptyState,
                            update: (EmptyState)->(),
                            dispatch: StoreDispatch) -> [AnyNodeDescription] {
    return []
  }
}
