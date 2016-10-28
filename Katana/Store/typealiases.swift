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
public typealias StoreMiddleware<StorageState: State> =
  (_ getState: @escaping () -> StorageState, _ dispatch: @escaping StoreDispatch) ->
    (_ next: @escaping StoreDispatch) ->
      (_ action: Action) -> Void

public typealias StoreDispatch = (_: Action) -> Void
