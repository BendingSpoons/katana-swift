//
//  SagaProvidersContainer.swift
//  ReKatana
//
//  Created by Mauro Bolis on 11/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

class SagaProvidersContainer<RootReducer: Reducer> {
  let store: Store<RootReducer>

  required init(store: Store<RootReducer>) {
    self.store = store
  }
}
