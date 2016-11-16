//
//  PostsProvider.swift
//  HackerNewsClient
//
//  Created by Francesco Di Lorenzo on 15/11/2016.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Katana

extension PostsProvider {
    static let hnFrontPageURL = URL(string: "https://hn.algolia.com/api/v1/search?tags=front_page")!
}

struct PostsProvider: SideEffectDependencyContainer {
    var posts: [Post]?

    init(state: State, dispatch: @escaping StoreDispatch) {}
    
    public func fetchPosts(completion: @escaping ([Post]?, String?) -> ()) {
        
        let task = URLSession.shared.dataTask(with: PostsProvider.hnFrontPageURL) { (data, response, error) in
            
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let hits = json?["hits"] as? [[String: Any]]
            else {
                completion(nil, "Unknown Error")
                return
            }
            
            var posts = [Post]()
            
            for hit in hits {
                guard let title = hit["title"] as? String,
                    let points = hit["points"] as? Int,
                    let url = (hit["url"] as? String) ?? (hit["story_url"] as? String)
                else {
                    continue
                }
                
                let post = Post(title: title, url: URL(string: url), points: points)
                posts.append(post)
            }
            
            completion(posts, nil)
        }
        
        task.resume()
    }
}
