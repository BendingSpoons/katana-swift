//
//  typealiases.swift
//  Katana
//
//  Created by Mauro Bolis on 29/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public typealias StoreListener = () -> Void
public typealias StoreUnsubscribe = () -> ()

public typealias StoreMiddleware<StateType: State> =
  (_ getState: @escaping () -> StateType, _ dispatch: @escaping StoreDispatch) ->
    (_ next: @escaping StoreDispatch) ->
      (_ action: AnyAction) -> Void

public typealias StoreDispatch = (_: AnyAction) -> Void
