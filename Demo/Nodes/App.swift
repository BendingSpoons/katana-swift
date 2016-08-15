//
//  App.swift
//  Katana
//
//  Created by Luca Querella on 10/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana

struct AppState : Equatable {
    var showPopup = true
    var password : [Int]?
    
    static func ==(lhs: AppState, rhs: AppState) -> Bool {
        return lhs.showPopup == rhs.showPopup && lhs.password == rhs.password
    }
    
}

struct App : NodeDescription {
    
    var props : EmptyProps
    var children: [AnyNodeDescription] = []
    
    static var initialState = AppState()
    static var viewType = UIView.self
    
    
    
    static func render(props: EmptyProps,
                       state: AppState,
                       children: [AnyNodeDescription],
                       update: (AppState)->()) -> [AnyNodeDescription] {
        
        
        print("render app \(state)")
        
        func onClose() {
            update(AppState(showPopup: false, password: state.password))
        }
        
        func onPasswordSet(_ password: [Int]) {
            update(AppState(showPopup: false, password: password))
        }

        
        if (state.showPopup) {
            return [
                Calculator(props: CalculatorProps().frame(props.frame.size), children: []),
                InstructionPopup(props: InstructionPopupProps()
                        .frame(props.frame.size)
                        .onClose(onClose), children: [])
            ]
            
        } else if (state.password == nil)  {
            return [
                Calculator(props: CalculatorProps()
                    .frame(props.frame.size)
                    .onPasswordSet(onPasswordSet), children: []),
            ]
        } else {
            return [
                View(props: ViewProps()
                    .frame(props.frame.size)
                    .color(.red))
            ]
        }
    }
}


