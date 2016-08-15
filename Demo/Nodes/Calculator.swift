//
//  Calculator.swift
//  Katana
//
//  Created by Luca Querella on 13/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana

struct CalculatorProps : Equatable,Frameable {
    var frame: CGRect = CGRect.zero
    var onPasswordSet: (([Int])->())?
    
    static func ==(lhs: CalculatorProps, rhs: CalculatorProps) -> Bool {
        return false
    }
    
    func onPasswordSet(_ onPasswordSet: (([Int])->())) -> CalculatorProps {
        var copy = self
        copy.onPasswordSet = onPasswordSet
        return copy
    }
}


struct Calculator : NodeDescription {
    
    var props : CalculatorProps
    var children: [AnyNodeDescription] = []
    
    static var initialState = EmptyState()
    static var viewType = UIView.self
    
    static func render(props: CalculatorProps,
                       state: EmptyState,
                       children: [AnyNodeDescription],
                       update: (EmptyState)->()) -> [AnyNodeDescription] {
        
        
        struct Cell {
            var text : String
            var color : UIColor
            var size : Int
        }
        
        struct Row {
            var cells : [Cell]
        }
        
        let rows = [
            Row(cells: [
                Cell(text: "C", color: UIColor(0xE7E2D5), size: 1),
                Cell(text: "+/-", color: UIColor(0xE7E2D5), size: 1),
                Cell(text: "%", color: UIColor(0xE7E2D5), size: 1),
                Cell(text: "÷", color: UIColor(0xFF4D1D), size: 1),
                ]),
            
            Row(cells: [
                Cell(text: "7", color: UIColor(0xE7E2D5), size: 1),
                Cell(text: "8", color: UIColor(0xE7E2D5), size: 1),
                Cell(text: "9", color: UIColor(0xE7E2D5), size: 1),
                Cell(text: "X", color: UIColor(0xFF4D1D), size: 1),
                ]),
            
            Row(cells: [
                Cell(text: "4", color: UIColor(0xE7E2D5), size: 1),
                Cell(text: "5", color: UIColor(0xE7E2D5), size: 1),
                Cell(text: "6", color: UIColor(0xE7E2D5), size: 1),
                Cell(text: "-", color: UIColor(0xFF4D1D), size: 1),
                ]),
            
            Row(cells: [
                Cell(text: "1", color: UIColor(0xE7E2D5), size: 1),
                Cell(text: "2", color: UIColor(0xE7E2D5), size: 1),
                Cell(text: "3", color: UIColor(0xE7E2D5), size: 1),
                Cell(text: "+", color: UIColor(0xFF4D1D), size: 1),
                ]),
            
            Row(cells: [
                Cell(text: "0", color: UIColor(0xE7E2D5), size: 2),
                Cell(text: ".", color: UIColor(0xE7E2D5), size: 1),
                Cell(text: "=", color: UIColor(0xFF4D1D), size: 1),
                ])
        ]
        
        
        var buttons : [AnyNodeDescription] = []
        
        for (rowNumber, row) in rows.enumerated() {
            
            var x = 0
            
            for (_, cell) in row.cells.enumerated() {
                
                let frame = CGRect(x: x,
                                   y: 74*rowNumber,
                                   width: 80*cell.size,
                                   height: 74)
                
                buttons.append(Button(props: ButtonProps()
                    .color(cell.color)
                    .frame(frame)
                    .borderWidth(0.5)
                    .text(cell.text, fontSize: 15)
                    .onTap({ 
                        props.onPasswordSet?([1,5,9,8])
                    })
                ))
                
                x += 80*cell.size
            }
        }
        
        let text = NSMutableAttributedString(string: "Define Passcode", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight),
            NSParagraphStyleAttributeName: NSParagraphStyle.centerAlignment,
            NSForegroundColorAttributeName : UIColor(0xE7E2D5)
        ])
        
        
        return [View(props: ViewProps().frame(props.frame).color(.black), children: [
            Text(props: TextProps().frame(40,40,240,30).color(.clear).text(text)),
            View(props: ViewProps().frame(0,110,320,370).color(.red), children: buttons)
        ])]
        
    }
    
}
