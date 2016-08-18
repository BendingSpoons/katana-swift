//
//  View.swift
//  Katana
//
//  Created by Luca Querella on 10/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

public struct TextProps: Equatable,Colorable,Frameable,Textable,TouchDisableable  {
  public var frame = CGRect.zero
  public var color = UIColor.white
  public var touchDisabled =  true
  public var text: NSAttributedString = NSAttributedString()
  
  public static func ==(lhs: TextProps, rhs: TextProps) -> Bool {
    return lhs.frame == rhs.frame &&
      lhs.color == rhs.color &&
      lhs.touchDisabled == rhs.touchDisabled &&
      lhs.text == rhs.text
  }
  
  public init() {}
}


public struct Text : NodeDescription {
  public var props : TextProps
  
  public static var initialState = EmptyState()
  public static var viewType = UILabel.self
  
  public static func renderView(props: TextProps, state: EmptyState, view: UILabel, update: (EmptyState)->())  {
    view.frame = props.frame
    view.backgroundColor = props.color
    view.isUserInteractionEnabled = !props.touchDisabled
    view.attributedText = props.text
  }
  
  public static func render(props: TextProps,
                            state: EmptyState,
                            update: (EmptyState)->()) -> [AnyNodeDescription] {
    return []
  }
  
  public init(props: TextProps) {
    self.props = props
  }
}

