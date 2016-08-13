//
//  CommonProps.swift
//  Katana
//
//  Created by Luca Querella on 10/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit


protocol Textable {
    var text : String {get set}
    func text(_ text: String) -> Self
}

extension Textable {
    func text(_ text: String) -> Self {
        var copy = self
        copy.text = text
        return copy
    }
}

protocol Colorable {
    var color : UIColor {get set}
    func color(_ color: UIColor) -> Self
}

extension Colorable {
    
    
    func color(_ color: UIColor) -> Self {
        var copy = self
        copy.color = color
        return copy
    }
}

public protocol Frameable {
    var frame : CGRect {get set}
    func frame(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> Self
    func frame(_: CGRect) -> Self

}

public extension Frameable {
    func frame(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> Self {
        var copy = self
        copy.frame = CGRect(x: x, y: y, width: width, height: height)
        return copy
    }
    
    func frame(_ frame: CGRect) -> Self {
        var copy = self
        copy.frame = frame
        return copy
    }
    
    func frame(_ size: CGSize) -> Self {
        var copy = self
        copy.frame = CGRect(origin: CGPoint.zero, size: size)
        return copy
    }
}

protocol TouchDisableable {
    var touchDisabled : Bool {get set}
    func disableTouch() -> Self
    func enableTouch(enable: Bool) -> Self


}

extension TouchDisableable {
    
    func disableTouch() -> Self {
        var copy = self
        copy.touchDisabled = true
        return copy
    }
    func enableTouch(enable: Bool) -> Self {
        var copy = self
        copy.touchDisabled = !enable
        return copy
    }
}

protocol Tappable {
    var onTap : (()->())? {get set}
    func onTap(_ onTap: ()->()) -> Self
}

extension Tappable {
    func onTap(_ onTap: ()->()) -> Self {
        var copy = self
        copy.onTap = onTap
        return copy
    }
}

public struct EmptyState : Equatable {
    public static func ==(lhs: EmptyState, rhs: EmptyState) -> Bool {
        return true
    }
}

public struct EmptyProps : Equatable, Frameable {
    
    public var frame: CGRect = CGRect.zero
    
    public static func ==(lhs: EmptyProps, rhs: EmptyProps) -> Bool {
        return lhs.frame == rhs.frame
    }
}
