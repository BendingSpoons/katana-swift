//
//  PostsProvider.swift
//  KatanaCodingLove
//
//  Created by Alain Caltieri on 09/11/16.
//  Copyright © 2016 dk.bendingspoons.Demo. All rights reserved.
//

import Foundation
import Katana

let POSTS_PER_PAGE = 3

struct PostsProvider: SideEffectDependencyContainer {
    var posts: [Post]
    
    public init(state: State, dispatch: @escaping StoreDispatch) {
        self.posts = [Post]()
    }
    
    public func fetchPosts(for page: Int, completion: @escaping (([Post], Bool)?, String?) -> ()) {
        DispatchQueue.global().async {
            let posts = Bundle.main.path(forResource: "posts", ofType: "json")
                    .flatMap { URL(fileURLWithPath: $0) }
                    .flatMap { try? Data(contentsOf: $0) }
                    .flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) }
                    .flatMap { $0 as? [[String: String]] }

            if let actualPosts = posts {
                var allFetched = false
                if ((page+1) * POSTS_PER_PAGE) >= posts!.count {
                    allFetched = true
                }
                
                let filteredPosts = Array(actualPosts[(page * POSTS_PER_PAGE)..<((page+1) * POSTS_PER_PAGE)])
                completion((self.parsePosts(postsToParse: filteredPosts), allFetched), nil)
            
            } else {
                completion(nil, "Could not fetch posts")
            }
        }
    }
    
    private func parsePosts(postsToParse: [[String: String]]) -> [Post] {
        var result = [Post]()
        for post in postsToParse {
            let title = post["title"]
            
            guard let imageUrl = URL(string: post["image_url"]!) else {
                continue  // Fail silently
            }
            
            guard let imageData = try? Data(contentsOf: imageUrl) else {
                continue  // Fail silently
            }
            
            result.append(Post(title: title!, imageData: imageData))
        }
        
        return result
    }
    
}

