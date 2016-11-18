//
//  Reload.swift
//  HackerNewsClient
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Katana

struct Reload: AsyncAction, ActionWithSideEffect {
    
  typealias LoadingPayload = ()
  typealias CompletedPayload = [Post]
  typealias FailedPayload = String
  
  var loadingPayload: LoadingPayload
  var completedPayload: CompletedPayload?
  var failedPayload: FailedPayload?
    
  var state: AsyncActionState = .loading
  
  init(payload: LoadingPayload) {
      self.loadingPayload = payload
  }
  
  func updatedStateForLoading(currentState: State) -> State {
    var newState = currentState as! HackerNewsState
    newState.loading = true
    return newState
  }
  
  func updatedStateForCompleted(currentState: State) -> State {
    var newState = currentState as! HackerNewsState
    newState.loading = false
    newState.posts = self.completedPayload!
    return newState
  }
  
  func updatedStateForFailed(currentState: State) -> State {
    var newState = currentState as! HackerNewsState
    newState.loading = false
    return newState
  }
  
  func sideEffect(state: State, dispatch: @escaping StoreDispatch, dependencies: SideEffectDependencyContainer) {
    let postsProvider = dependencies as! PostsProvider
    
    postsProvider.fetchPosts { (posts, error) in
      if let posts = posts {
        dispatch(self.completedAction(payload: posts))
      } else if let error = error {
        dispatch(self.failedAction(payload: error))
      }
    }
  }
  
}
