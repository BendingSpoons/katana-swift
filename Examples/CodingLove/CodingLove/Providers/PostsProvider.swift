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
    
    public func fetchPosts(page: Int,with completion: @escaping (([Post], Bool)?, String?) -> ()) {
        DispatchQueue.global().async {
            if let path = Bundle.main.path(forResource: "posts", ofType: "json") {
                let jsonData = try! NSData(contentsOfFile: path, options: .mappedIfSafe)
                if let posts: Array<Dictionary<String, String>> = try! JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? Array<Dictionary<String, String>> {
                    var allFetched = false
                    if ((page+1) * POSTS_PER_PAGE) >= posts.count {
                        allFetched = true
                    }
                    
                    let actualPosts = Array(posts[(page * POSTS_PER_PAGE)..<((page+1) * POSTS_PER_PAGE)])
                    completion((self.parsePosts(postsToParse: actualPosts), allFetched), nil)
                }
            }
            completion(nil, "Could not fetch posts")
        }
    }
    
    private func parsePosts(postsToParse: Array<Dictionary<String, String>>) -> [Post] {
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

