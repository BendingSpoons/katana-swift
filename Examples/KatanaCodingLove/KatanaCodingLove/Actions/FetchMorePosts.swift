//
//  LoadPosts.swift
//  Katana
//
//  Created by Alain Caltieri on 07/11/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import Katana

let POSTS_PER_PAGE = 1

struct FetchMorePosts: AsyncAction, ActionWithSideEffect {
    
    public static func sideEffect(action: FetchMorePosts, state: State, dispatch: @escaping StoreDispatch, dependencies: SideEffectDependencyContainer) {
        if action.state != .loading {
            return
        }
        
        let castedState = state as! CodingLoveState
        let page: Int = castedState.page
        DispatchQueue.global().async {
            // Read the file from bundle, faking a network request for now
            if let path = Bundle.main.path(forResource: "posts", ofType: "json")
            {
                let jsonData = try! NSData(contentsOfFile: path, options: .mappedIfSafe)
                if let posts: Array<Dictionary<String, String>> = try! JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? Array<Dictionary<String, String>>
                {
                    var actualPosts = [Dictionary<String, String>]()
                    for index in (page * POSTS_PER_PAGE)..<((page+1) * POSTS_PER_PAGE) {
                        if index < posts.count {
                            actualPosts.append(posts[index])
                        }
                    }
                    var result = [Post]()
                    for post in actualPosts {
                        let title = post["title"]
                        
                        guard let imageUrl = URL(string: post["image_url"]!) else {
                            continue  // Fail silently
                        }
                        
                        guard let imageData = try? Data(contentsOf: imageUrl) else {
                            continue  // Fail silently
                        }
                        
                        result.append(Post(title: title!, imageData: imageData))
                        
                    }
                    dispatch(action.completedAction(payload: result))
                }
            }
            dispatch(action.failedAction(payload: "Some error occurred fetching posts"))
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
        newState.page += 1
        return newState
    }
    
    static func updatedStateForCompleted(currentState: State, action: FetchMorePosts) -> State {
        var newState = currentState as! CodingLoveState
        newState.loading = false
        newState.posts += action.completedPayload!
        return newState
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
