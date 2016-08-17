//
//  App.swift
//  Katana
//
//  Created by Luca Querella on 10/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana

struct InstructionPopupProps : Equatable,Frameable,Keyable {
  var frame: CGRect = CGRect.zero
  var onClose: (()->())?
  var key: String?
  
  func onClose(_ onClose: (()->())?) -> InstructionPopupProps {
    var copy = self
    copy.onClose = onClose
    return copy
  }
  
  static func ==(lhs: InstructionPopupProps, rhs: InstructionPopupProps) -> Bool {
    return false
  }
}

struct InstructionPopup : NodeDescription {
  
  var props : InstructionPopupProps
  var children: [AnyNodeDescription] = []
  
  static var initialState = EmptyState()
  static var viewType = UIView.self
  
  
  
  static func render(props: InstructionPopupProps,
                     state: EmptyState,
                     children: [AnyNodeDescription],
                     update: (EmptyState)->()) -> [AnyNodeDescription] {
    
    
    
    let text = NSMutableAttributedString(string: "Instructions", attributes: [
      NSFontAttributeName : UIFont.systemFont(ofSize: 22, weight: UIFontWeightRegular),
      NSParagraphStyleAttributeName: NSParagraphStyle.centerAlignment
      ])
    
    let textButton = NSMutableAttributedString(string: "OK", attributes: [
      NSFontAttributeName : UIFont.systemFont(ofSize: 17, weight: UIFontWeightRegular),
      NSParagraphStyleAttributeName: NSParagraphStyle.centerAlignment,
      NSForegroundColorAttributeName : UIColor(colorLiteralRed: 1, green: 0, blue: 0, alpha: 1)
      ])
    
    return [
      
      Popup(props: EmptyProps().frame(props.frame.size), children: [
        View(props: ViewProps().frame(0,0,270,400).color(0xE7E2D5), children:[
          Text(props: TextProps().frame(0,0,270,95)
            .text(text)
            .color(.clear)),
          
          ]),
        Button(props: ButtonProps().frame(0,360,270,40)
          .color(.white)
          .color(.gray, state: .highlighted)
          .onTap(props.onClose)
          .text(textButton))
        
        ])
    ]
    
  }
}


