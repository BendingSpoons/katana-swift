//
//  CommonProps.swift
//  Katana
//
//  Created by Luca Querella on 10/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana

public protocol Textable {
  var text: NSAttributedString {get set}
  func text(_ text: NSAttributedString) -> Self
  func text(_ text: String, fontSize: CGFloat) -> Self
}

extension Textable {
  public func text(_ text: NSAttributedString) -> Self {
    var copy = self
    copy.text = text
    return copy
  }
  
  public func text(_ text: String, fontSize: CGFloat) -> Self {
    
    let attriburedText = NSMutableAttributedString(string: text as String, attributes: [
      NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: UIFontWeightRegular),
      NSParagraphStyleAttributeName: NSParagraphStyle.centerAlignment,
      NSForegroundColorAttributeName: UIColor(0x000000)
      ])
    
    
    var copy = self
    copy.text = attriburedText
    return copy
  }
}

public protocol Colorable {
  var color: UIColor {get set}
  func color(_ color: UIColor) -> Self
}

extension Colorable {
  
  
  public func color(_ color: UIColor) -> Self {
    var copy = self
    copy.color = color
    return copy
  }
  
  public func color(_ hex: Int) -> Self {
    return color(UIColor(hex))
  }
}

public protocol TouchDisableable {
  var touchDisabled: Bool {get set}
  func disableTouch() -> Self
  func enableTouch(enable: Bool) -> Self
  
  
}

extension TouchDisableable {
  
  public func disableTouch() -> Self {
    var copy = self
    copy.touchDisabled = true
    return copy
  }
  public func enableTouch(enable: Bool) -> Self {
    var copy = self
    copy.touchDisabled = !enable
    return copy
  }
}

public protocol Tappable {
  var onTap : (()->())? {get set}
  func onTap(_ onTap: (()->())?) -> Self
}

extension Tappable {
  public func onTap(_ onTap: (()->())?) -> Self {
    var copy = self
    copy.onTap = onTap
    return copy
  }
}

public protocol CornerRadiusable {
  var cornerRadius: CGFloat {get set}
  func cornerRadius(_ cornerRadius: CGFloat) -> Self
}

extension CornerRadiusable {
  public func cornerRadius(_ cornerRadius: CGFloat) -> Self {
    var copy = self
    copy.cornerRadius = cornerRadius
    return copy
  }
}

public protocol Bordable {
  var borderColor: UIColor {get set}
  var borderWidth: CGFloat {get set}
  
  func borderColor(_ borderColor: UIColor) -> Self
  func borderWidth(_ borderWidth: CGFloat) -> Self
  
}

extension Bordable {
  public func borderColor(_ borderColor: UIColor) -> Self {
    var copy = self
    copy.borderColor = borderColor
    return copy
  }
  
  public func borderWidth(_ borderWidth: CGFloat) -> Self {
    var copy = self
    copy.borderWidth = borderWidth
    return copy
  }
}

public protocol Highlightable {
  var highlighted: Bool { get set }
}

public struct EmptyHighlightableState: NodeState, Highlightable {
  public var highlighted: Bool
  
  public init() {
    self.highlighted = false
  }
  
  public init(highlighted: Bool) {
    self.highlighted = highlighted
  }
  
  public static func == (lhs: EmptyHighlightableState, rhs: EmptyHighlightableState) -> Bool {
    return lhs.highlighted == rhs.highlighted
  }
}
