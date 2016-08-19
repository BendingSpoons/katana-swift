//
//  Calculator.swift
//  Katana
//
//  Created by Luca Querella on 13/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana

struct CalculatorProps : Equatable,Frameable,Keyable {
  var frame: CGRect = CGRect.zero
  var onPasswordSet: (([Int])->())?
  var key: String?
  
  static func ==(lhs: CalculatorProps, rhs: CalculatorProps) -> Bool {
    return false
  }
  
  func onPasswordSet(_ onPasswordSet: (([Int])->())) -> CalculatorProps {
    var copy = self
    copy.onPasswordSet = onPasswordSet
    return copy
  }
}

private struct Cell {
  var text : String
  var color : UIColor
}

private struct Row {
  var cells : [Cell]
}

struct Calculator : NodeDescription, PlasticNodeDescription {
  static var initialState = EmptyState()
  static var nativeViewType = UIView.self

  var props : CalculatorProps
  
  static func render(props: CalculatorProps,
                     state: EmptyState,
                     update: (EmptyState)->()) -> [AnyNodeDescription] {    
    let rows = [
      Row(cells: [
        Cell(text: "C", color: UIColor(0xE7E2D5)),
        Cell(text: "+/-", color: UIColor(0xE7E2D5)),
        Cell(text: "%", color: UIColor(0xE7E2D5)),
        Cell(text: "÷", color: UIColor(0xFF4D1D)),
        ]),
      
      Row(cells: [
        Cell(text: "7", color: UIColor(0xE7E2D5)),
        Cell(text: "8", color: UIColor(0xE7E2D5)),
        Cell(text: "9", color: UIColor(0xE7E2D5)),
        Cell(text: "X", color: UIColor(0xFF4D1D)),
        ]),
      
      Row(cells: [
        Cell(text: "4", color: UIColor(0xE7E2D5)),
        Cell(text: "5", color: UIColor(0xE7E2D5)),
        Cell(text: "6", color: UIColor(0xE7E2D5)),
        Cell(text: "-", color: UIColor(0xFF4D1D)),
        ]),
      
      Row(cells: [
        Cell(text: "1", color: UIColor(0xE7E2D5)),
        Cell(text: "2", color: UIColor(0xE7E2D5)),
        Cell(text: "3", color: UIColor(0xE7E2D5)),
        Cell(text: "+", color: UIColor(0xFF4D1D)),
        ]),
      
      Row(cells: [
        Cell(text: "0", color: UIColor(0xE7E2D5)),
        Cell(text: ".", color: UIColor(0xE7E2D5)),
        Cell(text: "=", color: UIColor(0xFF4D1D)),
        ])
    ]
    
    
    var buttons : [AnyNodeDescription] = []
    
    for (rowNumber, row) in rows.enumerated() {
      for (cellNumber, cell) in row.cells.enumerated() {
        buttons.append(Button(props: ButtonProps()
          .color(cell.color)
          .key("button-\(rowNumber)-\(cellNumber)")
          .borderWidth(0.5)
          .text(cell.text, fontSize: 15)
          .onTap({
            props.onPasswordSet?([1,5,9,8])
          })
        ))
      }
    }
    
    let text = NSMutableAttributedString(string: "Define Passcode", attributes: [
      NSFontAttributeName : UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight),
      NSParagraphStyleAttributeName: NSParagraphStyle.centerAlignment,
      NSForegroundColorAttributeName : UIColor(0xE7E2D5)
    ])
    
    return [
      View(props: ViewProps().key("container").color(.black)) {
        [
          Text(props: TextProps().key("number-display").color(.clear).text(text)),
          View(props: ViewProps().key("buttons-container").color(.red).children(buttons))
        ]
      }
    ]
  }
  
  static func layout(views: ViewsContainer, props: CalculatorProps, state: EmptyState) -> Void {
    let root = views.rootView
    let container = views["container"]!
    let numberDisplay = views["number-display"]!
    let buttonsContainer = views["buttons-container"]!
    let btnFirstRow = views.orderedViews(withPrefix: "button-0", sortedBy: <)
    let btnSecondRow = views.orderedViews(withPrefix: "button-1", sortedBy: <)
    let btnThirdRow = views.orderedViews(withPrefix: "button-2", sortedBy: <)
    let btnFourthRow = views.orderedViews(withPrefix: "button-3", sortedBy: <)
    let btnFifthRow = views.orderedViews(withPrefix: "button-4", sortedBy: <)
    
    container.fill(root)
    
    buttonsContainer.fill(top: root.top, left: root.left, bottom: root.bottom, right: root.right, aspectRatio: 4.0/5.0)
    buttonsContainer.bottom = root.bottom
    
    numberDisplay.asHeader(root)
    numberDisplay.bottom = buttonsContainer.top
    
    let cellHeight = buttonsContainer.height / 5.0
    var prevRowBottom = buttonsContainer.top
    
    for row in [btnFirstRow, btnSecondRow, btnThirdRow, btnFourthRow] {
      for btn in row {
        btn.height = cellHeight
        btn.top = prevRowBottom
      }
      
      row.fill(left: buttonsContainer.left, right: buttonsContainer.right)
      prevRowBottom = row[0].bottom
    }
    
    // last row is special because of the double button
    for btn in btnFifthRow {
      btn.height = cellHeight
      btn.top = btnFourthRow[0].bottom
    }
    
    btnFifthRow.fill(
      left: buttonsContainer.left,
      right: buttonsContainer.right,
      insets: .zero,
      spacings: nil,
      widths: [2, 1, 1]
    )
  }
}
