//
//  types.swift
//  ReKatana
//
//  Created by Mauro Bolis on 09/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

// only used internally
typealias AnySaga = (action: Action, getState: Any, dispatch: StoreDispatch) -> Void

//NB this will be public, while AnySaga will be used only internally
//NB: can't use StoreGetState alias here since the compiler will go into a kind of infinite loop.. well done Apple :)
public typealias Saga<ManagedAction: Action, RootReducer: Reducer> = (action: ManagedAction, getState: () -> RootReducer.StateType, dispatch: StoreDispatch) -> Void
