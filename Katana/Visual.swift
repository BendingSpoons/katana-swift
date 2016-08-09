//
//  Visua.swift
//  Katana
//
//  Created by Luca Querella on 03/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import UIKit

public struct ViewProps: Equatable, Colorable,Frameable  {
    public var frame = CGRect.zero
    public var color = UIColor.white
    
    public static func ==(lhs: ViewProps, rhs: ViewProps) -> Bool {
        return lhs.frame == rhs.frame && lhs.color == rhs.color
    }
    
    public init() {}
}

public struct View : Visual {
    
    public static func applyProps(props: ViewProps, view: UIView) {
        view.frame = props.frame
        view.backgroundColor = props.color
    }
    public init() {}

}

public struct TextProps: Equatable, Colorable, Frameable, Textable  {
    
    var frame = CGRect.zero
    var color = UIColor.white
    var text = ""
    
    public static func ==(lhs: TextProps, rhs: TextProps) -> Bool {
        return lhs.frame == rhs.frame && lhs.color == rhs.color && lhs.text == rhs.text
    }
}

public struct Text : Visual {
    public static func applyProps(props: TextProps, view: UILabel) {
        view.frame = props.frame
        view.text = props.text
        view.backgroundColor = props.color
    }
}

public struct ButtonsProps: Equatable, Colorable, Frameable, Textable,Tappable  {
    
    var frame = CGRect.zero
    var color = UIColor.white
    var text = ""
    var onTap: (() -> ())?
    
    public static func ==(lhs: ButtonsProps, rhs: ButtonsProps) -> Bool {
        return false
    }

}

struct Button : Visual {
    static func applyProps(props: ButtonsProps, view: UIButton) {
        view.frame = props.frame
        view.setTitle(props.text, for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.backgroundColor = props.color
        view.block = props.onTap
    }
}


class UIButton : UIKit.UIButton {
    
    var block : (()->())? {
        didSet {
            self.addTarget(self, action: #selector(tap), for: .touchDown)
        }
        
        willSet {
            self.removeTarget(nil, action: nil, for: .allEvents)
        }
    }
    
    func tap() {
        block?()
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

protocol Frameable {
    var frame : CGRect {get set}
    func frame(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> Self
}

extension Frameable {
    func frame(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> Self {
        var copy = self
        copy.frame = CGRect(x: x, y: y, width: width, height: height)
        return copy
    }
}
