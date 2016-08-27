//  types.swift
//  ReKatana
//
//  Created by Mauro Bolis on 09/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

// only used internally
typealias AnySaga = (_ action: Action, _ getState: Any, _ dispatch: StoreDispatch, _ providers: Any) -> Void

//NB this will be public, while AnySaga will be used only internally
//NB: can't use StoreGetState alias here since the compiler will go into a kind of infinite loop.. well done Apple :)
public typealias Saga<ManagedAction: Action, RootReducer: Reducer, Providers: SagaProvidersContainer<RootReducer>> = (_ action: ManagedAction, _ getState: () -> RootReducer.StateType, _ dispatch: StoreDispatch, _ providers: Providers) -> Void

