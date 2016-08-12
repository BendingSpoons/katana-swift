//
//  SagaModule+Action.swift
//  ReKatana
//
//  Created by Mauro Bolis on 10/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

extension SagaModule {
  
  mutating func addSaga<ManagedAction: Action, RootReducer: Reducer, Providers: SagaProvidersContainer<RootReducer>, Payload>(
    _ saga: (
      action: ManagedAction,
      getState: () -> RootReducer.StateType,
      dispatch: StoreDispatch,
      providers: Providers
    ) -> Void,
    forActionCreator actionCreator: SyncActionCreator<Payload>
  ) -> Void {
    
    self.addSaga(saga, forActionNamed: actionCreator.actionName)
  }
  
  mutating func addSaga<ManagedAction: Action, RootReducer: Reducer, Providers: SagaProvidersContainer<RootReducer>, Payload, CompletedPayload, ErrorPayload>(
    _ saga: (
    action: ManagedAction,
    getState: () -> RootReducer.StateType,
    dispatch: StoreDispatch,
    providers: Providers
    ) -> Void,
    forActionCreator actionCreator: AsyncActionCreator<Payload, CompletedPayload, ErrorPayload>
    ) -> Void {
    
    self.addSaga(saga, forActionNamed: actionCreator.actionName)
  }
}
