//
//  LoadPosts.swift
//  Katana
//
//  Created by Alain Caltieri on 07/11/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import Katana

struct FetchMorePosts: AsyncAction, ActionWithSideEffect {
    
    public static func sideEffect(action: FetchMorePosts, state: State, dispatch: @escaping StoreDispatch, dependencies: SideEffectDependencyContainer) {
        DispatchQueue.global().async {
            let page = try! String(contentsOf: URL(string: "http://thecodinglove.com/random")!)
            let title = (page.capturedGroups(withRegex: "<div class=\"centre\"> <h3>([^<]+)</h3> </div>")?[0])!
            let imageUrl = (page.capturedGroups(withRegex: "<p class=\"e\"><img src=\"([^\"]+)\">")?[0])!

            let url = URL(string: imageUrl)!
            let data = NSData(contentsOf: url)
            dispatch(action.completedAction(payload: [Post(title: title, image: UIImage.gifWithData(data as! Data)!)]))
        }
    }


    /// The loading payload of the action
    public var loadingPayload: String
    public var completedPayload: Array<Post>?
    public var failedPayload: String?
    
    /// The state of the action
    public var state: AsyncActionState = .loading

    
    typealias LoadingPayload = String
    typealias CompletedPayload = [Post]
    typealias FailedPayload = String
    
    static func updatedStateForLoading(currentState: State, action: FetchMorePosts) -> State {
        var newState = currentState as! CodingLoveState
        newState.loading = true
        return newState
    }
    
    static func updatedStateForCompleted(currentState: State, action: FetchMorePosts) -> State {
        return currentState
    }
    
    static func updatedStateForFailed(currentState: State, action: FetchMorePosts) -> State {
        var newState = currentState as! CodingLoveState
        newState.loading = false
        return newState
        // TODO
    }
    
    init(payload: LoadingPayload) {
        self.loadingPayload = payload
    }
}
