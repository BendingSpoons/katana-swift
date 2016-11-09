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
    
    // FIXME: refactor
    public static func sideEffect(action: FetchMorePosts, state: State, dispatch: @escaping StoreDispatch, dependencies: SideEffectDependencyContainer) {
        // FIXME: this shall be removed after it's fixed in Katana
        if action.state != .loading {
            return
        }
        
        let castedState = state as! CodingLoveState
        let page: Int = castedState.page
        
        DispatchQueue.global().async {
            // Read the file from bundle, faking a network request.
            if let path = Bundle.main.path(forResource: "posts", ofType: "json") {
                let jsonData = try! NSData(contentsOfFile: path, options: .mappedIfSafe)
                if let posts: Array<Dictionary<String, String>> = try! JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? Array<Dictionary<String, String>> {
                    let actualPosts = posts[(page * POSTS_PER_PAGE)..<((page+1) * POSTS_PER_PAGE)]
                    var allFetched = false
                    if ((page+1) * POSTS_PER_PAGE) >= posts.count {
                        allFetched = true
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
                    dispatch(action.completedAction(payload: CompletedActionPayload(posts: result, allFetched: allFetched)))
                }
            }
            dispatch(action.failedAction(payload: "Some error occurred fetching posts"))
        }
    }
}
