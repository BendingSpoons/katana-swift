//
//  Button.swift
//  Katana
//
//  Created by Luca Querella on 10/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit



public struct ButtonProps: Equatable, Colorable, Frameable, Textable, Tappable,Bordable  {
  public enum State {
    case normal
    case highlighted
  }
  
  public var frame = CGRect.zero
  public var color = UIColor.white
  public var highlightedColor = UIColor.white
  public var onTap: (() -> ())?
  public var text = NSAttributedString()
  public var borderColor = UIColor.black
  public var borderWidth = CGFloat(0)
  
  public static func ==(lhs: ButtonProps, rhs: ButtonProps) -> Bool {
    return false
  }
  
  public func color(_ color: UIColor, state: State) -> ButtonProps {
    var copy = self
    switch state {
    case .highlighted:
      copy.highlightedColor = color
      break
    default:
      copy.color = color
    }
    
    return copy
  }
  
  public init() {}
}

public struct Button : NodeDescription {
  public var props : ButtonProps
  
  public static var initialState = false
  public static var viewType = UIView.self
  
  public init(props: ButtonProps) {
    self.props = props
  }
  
  public static func render(props: ButtonProps,
                            state: Bool,
                            update: (Bool)->()) -> [AnyNodeDescription] {
    
    func touchHandler(pressed: Bool) {
      update(pressed)
      if (!pressed) {
        props.onTap?()
      }
    }
    
    return [
      TouchHandler(props: TouchHandlerProps().frame(props.frame.size).touchHandler(touchHandler)) {
        [
          View(props: ViewProps()
            .frame(props.frame.size)
            .color(state ? props.highlightedColor : props.color )
            .borderColor(props.borderColor)
            .borderWidth(props.borderWidth)
            .disableTouch())
        ]
      },

      Text(props: TextProps()
        .frame(props.frame.size)
        .text(props.text)
        .color(.clear))
      ]
  }
}
