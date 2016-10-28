//
//  Button.swift
//  Katana
//
//  Created by Luca Querella on 10/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana

public struct ButtonProps: NodeProps, Colorable, Textable, Tappable, Bordable, Keyable {
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
  public var key: String?
  
  public static func == (lhs: ButtonProps, rhs: ButtonProps) -> Bool {
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

public struct Button: NodeDescription {
  public var props: ButtonProps
  
  public init(props: ButtonProps) {
    self.props = props
  }
  
  public static func render(props: ButtonProps,
                            state: EmptyHighlightableState,
                            update: @escaping (EmptyHighlightableState)->(),
                            dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    
    func touchHandler(pressed: Bool) {
      update(EmptyHighlightableState(highlighted: pressed))
      
      if !pressed {
        props.onTap?()
      }
    }
    
    return [
      TouchHandler(props: TouchHandlerProps().frame(props.frame.size).touchHandler(touchHandler)) {
        [
          View(props: ViewProps()
            .frame(props.frame.size)
            .color(state.highlighted ? props.highlightedColor : props.color)
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
