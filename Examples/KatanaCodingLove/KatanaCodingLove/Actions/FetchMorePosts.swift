//
//  LoadPosts.swift
//  Katana
//
//  Created by Alain Caltieri on 07/11/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import Katana

let POSTS_PER_PAGE = 3

struct FetchMorePosts: AsyncAction, ActionWithSideEffect {
    
    public struct CompletedActionPayload {
        var posts: Array<Post>
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
    
    public static func sideEffect(action: FetchMorePosts, state: State, dispatch: @escaping StoreDispatch, dependencies: SideEffectDependencyContainer) {
        // FIXME: this shall be removed after it's fixed in Katana
        if action.state != .loading {
            return
        }
        
        let castedState = state as! CodingLoveState
        let page: Int = castedState.page
        
        let postsProvider = dependencies as! PostsProvider
        
        postsProvider.fetchPosts(page: page, with: { (posts, allFetched, errorMessage) in
            if let fetchedPosts = posts {
                dispatch(action.completedAction(payload: CompletedActionPayload(posts: fetchedPosts, allFetched: allFetched)))
            
            } else {
                dispatch(action.failedAction(payload: errorMessage!))
            }
        })
    }
}
