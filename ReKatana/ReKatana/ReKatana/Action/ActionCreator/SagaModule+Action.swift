//
//  SagaModule+Action.swift
//  ReKatana
//
//  Created by Mauro Bolis on 10/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation


extension SagaModule {
  mutating func addSaga<ManagedAction: Action, RootState, Payload>(
    _ saga: (action: ManagedAction, getState: () -> RootState, dispatch: StoreDispatch) -> Void,
    forActionCreator actionCreator: SyncActionCreator<Payload>
    ) -> Void {
    
    self.addSaga(saga, forActionNamed: actionCreator.actionName)
  }
  
  mutating func addSaga<ManagedAction: Action, RootState, Payload, CompletedPayload, ErrorPayload>(
    _ saga: (action: ManagedAction, getState: () -> RootState, dispatch: StoreDispatch) -> Void,
    forActionCreator actionCreator: AsyncActionCreator<Payload, CompletedPayload, ErrorPayload>
    ) -> Void {
    
    self.addSaga(saga, forActionNamed: actionCreator.actionName)
  }
}
