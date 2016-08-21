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

struct InstructionPopup : NodeDescription, PlasticNodeDescription {
  static var initialState = EmptyState()
  static var nativeViewType = UIView.self

  var props : InstructionPopupProps
  
  static func render(props: InstructionPopupProps,
                     state: EmptyState,
                     update: (EmptyState)->(),
                     dispatch: StoreDispatch) -> [AnyNodeDescription] {
    
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
      View(props: ViewProps()
          .key("overlay")
          .color(UIColor(white: 0, alpha: 0.8))),

      View(props: ViewProps()
        .key("container")
        .color(0xE7E2D5)
        .cornerRadius(10)) {
          [
            Text(props: TextProps()
              .key("title")
              .text(text)
              .color(.clear)),

            Button(props: ButtonProps()
              .key("button")
              .color(.white)
              .color(.gray, state: .highlighted)
              .onTap(props.onClose)
              .text(textButton))
          ]
        }
    ]
  }
  
  static func layout(views: ViewsContainer,
                     props: InstructionPopupProps,
                     state: EmptyState) -> Void {
    
    let overlay = views["overlay"]!
    let container = views["container"]!
    let button = views["button"]!
    let title = views["title"]!
    let root = views.rootView
    
    overlay.fill(root)
    
    container.width = root.width * 0.8
    container.height = root.height * 0.8
    container.center(root)
    
    title.asHeader(container)
    title.height = .scalable(190)
    
    button.asFooter(container)
    button.height = .scalable(80)
  }
}


