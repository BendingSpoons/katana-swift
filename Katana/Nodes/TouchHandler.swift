//
//  Button.swift
//  Katana
//
//  Created by Luca Querella on 10/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

public struct TouchHandlerProps: Equatable, Frameable, Childrenable  {
  public var frame = CGRect.zero
  public var children: [AnyNodeDescription] = []

  var touchHandler: ((Bool) -> ())?
  
  public static func ==(lhs: TouchHandlerProps, rhs: TouchHandlerProps) -> Bool {
    if lhs.children.count + rhs.children.count > 0 {
      // Euristic, we always rerender when there is at least 1 child
      return false
    }
    
    return true
  }
  
  public func touchHandler(_ touchHandler: (Bool)->()) -> TouchHandlerProps {
    var copy = self
    copy.touchHandler = touchHandler
    return copy
  }
  
  public init() {}
}

public struct TouchHandler : NodeDescription, NodeWithChildrenDescription {
  public typealias NativeView = TouchHandlerView
  
  public var props : TouchHandlerProps
  
  public static var initialState = EmptyState()
  
  public static func applyPropsToNativeView(props: TouchHandlerProps,
                                            state: EmptyState,
                                            view: TouchHandlerView,
                                            update: (EmptyState)->(),
                                            node: AnyNode)  {
    view.frame = props.frame
    view.handler = props.touchHandler
  }
  
  public static func render(props: TouchHandlerProps,
                            state: EmptyState,
                            update: (EmptyState)->(),
                            dispatch: StoreDispatch) -> [AnyNodeDescription] {
    
    return props.children
  }
  
  public init(props: TouchHandlerProps) {
    self.props = props
  }
  
  public init(props: TouchHandlerProps, _ children: @noescape () -> [AnyNodeDescription]) {
    self.props = props
    self.props.children = children()
  }
}


public class TouchHandlerView : UIControl {
  
  private var touching : Bool = false
  public var handler : ((Bool)->())?
  
  public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    
    if self.touching  {
      return false
    }
    
    self.touching = true
    self.handler?(self.touching)
    return true
  }
  
  
  public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
    if (touching) {
      self.touching = false
      self.handler?(self.touching)
    }
  }
  
  public override func cancelTracking(with event: UIEvent?) {
    if (touching) {
      self.touching = false
      self.handler?(self.touching)
    }
  }
}
