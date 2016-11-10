//
//  LoadPosts.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Katana

struct FetchMorePosts: AsyncAction, ActionWithSideEffect {
    
    public struct CompletedActionPayload {
        var posts: [Post]
        var allFetched: Bool = false
    }

    typealias LoadingPayload = Void
    typealias CompletedPayload = CompletedActionPayload
    typealias FailedPayload = String

    public var loadingPayload: LoadingPayload
    public var completedPayload: CompletedPayload?
    public var failedPayload: FailedPayload?
    
    public var state: AsyncActionState = .loading
    
    init(payload: LoadingPayload) {
        self.loadingPayload = payload
    }
    
    static func updatedStateForLoading(currentState: State, action: FetchMorePosts) -> State {
        var newState = currentState as! CodingLoveState
        newState.loading = true
        newState.page += 1
        return newState
    }
    
    static func updatedStateForCompleted(currentState: State, action: FetchMorePosts) -> State {
        var newState = currentState as! CodingLoveState
        newState.loading = false
        newState.posts += (action.completedPayload?.posts)!
        newState.allPostsFetched = (action.completedPayload?.allFetched)!
        return newState
    }
    
    static func updatedStateForFailed(currentState: State, action: FetchMorePosts) -> State {
        var newState = currentState as! CodingLoveState
        newState.loading = false
        return newState
    }
    
    public static func sideEffect(
        action: FetchMorePosts,
        state: State,
        dispatch: @escaping StoreDispatch,
        dependencies: SideEffectDependencyContainer
    ) {
        
        let castedState = state as! CodingLoveState
        let page: Int = castedState.page
        
        let postsProvider = dependencies as! PostsProvider
        
        postsProvider.fetchPosts(for: page) { (result, errorMessage) in
            if let data = result {
                let (posts, allFetched) = data
                dispatch(action.completedAction(payload: CompletedActionPayload(posts: posts, allFetched: allFetched)))
            
            } else {
                dispatch(action.failedAction(payload: errorMessage!))
            }
        }
    }
}
