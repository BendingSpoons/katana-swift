//
//  SagaModule+Action.swift
//  ReKatana
//
//  Created by Mauro Bolis on 10/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

// TODO: remove this and use sagaTypes as soon as the typealias bug has been fixed
public typealias Saga3<ManagedAction: Action, RootReducer: Reducer, Providers: SagaProvidersContainer<RootReducer>> = (action: ManagedAction, getState: () -> RootReducer.StateType, dispatch: StoreDispatch, providers: Providers) -> Void

extension SagaModule {
  mutating func addSaga<RootReducer: Reducer, Providers: SagaProvidersContainer<RootReducer>, Payload>(
    _ saga: Saga3<SyncAction<Payload>, RootReducer, Providers>,
    forActionCreator actionCreator: SyncActionCreator<Payload>
  ) -> Void {

    self.addSaga(saga, forActionNamed: actionCreator.actionName)
  }
  
  mutating func addSaga<RootReducer: Reducer, Providers: SagaProvidersContainer<RootReducer>, Payload, CompletedPayload, ErrorPayload>(
    _ saga: Saga3<AsyncAction<Payload, CompletedPayload, ErrorPayload>, RootReducer, Providers>,
    forActionCreator actionCreator: AsyncActionCreator<Payload, CompletedPayload, ErrorPayload>
    ) -> Void {
    
    /*
      The original saga is wrapped in this closure because we want to really dispatch the saga only when
      the state is loading. Here we implement this behaviour
    */
    let filteredSaga: Saga3<AsyncAction<Payload, CompletedPayload, ErrorPayload>, RootReducer, Providers> = {
      action, getState, dispatch, providers in

      if action.state == .loading {
        saga(action: action, getState: getState, dispatch: dispatch, providers: providers)
      }
    }
    
    self.addSaga(filteredSaga, forActionNamed: actionCreator.actionName)
  }
}
