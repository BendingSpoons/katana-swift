//
//  SagaModule.swift
//  ReKatana
//
//  Created by Mauro Bolis on 09/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

public struct SagaModule {
  private(set) var sagas: [String: AnySaga] = [:]
  
  mutating func addSaga<ManagedAction: Action, RootState>(
    _ saga: (action: ManagedAction, getState: () -> RootState, dispatch: StoreDispatch) -> Void,
    forAction action: ManagedAction.Type
  ) {
    sagas[action.actionName()] = { action, getState, dispatch in
      if let a = action as? ManagedAction, let gS = getState as? () -> RootState {
        saga(action: a, getState: gS, dispatch: dispatch)
        return
      }
    
      assertionFailure("This should not happen, it is most likely a bug in the library. Please open an issue")
    }
  }
}
