//
//  PostsProvider.swift
//  KatanaCodingLove
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Katana

let postsPerPage = 3

class PostsProvider: SideEffectDependencyContainer {
    public required init(dispatch: @escaping StoreDispatch, getState: @escaping () -> State) {}

    public func fetchPosts(for page: Int, completion: @escaping (([Post], Bool)?, String?) -> ()) {
        DispatchQueue.global().async {
            let posts = Bundle.main.path(forResource: "posts", ofType: "json")
                    .flatMap { URL(fileURLWithPath: $0) }
                    .flatMap { try? Data(contentsOf: $0) }
                    .flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) }
                    .flatMap { $0 as? [[String: String]] }

            if let actualPosts = posts {
                var allFetched = false
                if ((page+1) * postsPerPage) >= posts!.count {
                    allFetched = true
                }
                
                let filteredPosts = Array(actualPosts[(page * postsPerPage)..<((page+1) * postsPerPage)])
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
