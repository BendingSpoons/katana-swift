//
//  PostsProvider.swift
//  HackerNewsClient
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

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
          
      let hits = data
        .flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) as? [String: Any] }
        .flatMap { $0?["hits"] as? [[String: Any]] }
      
      if let hits = hits {
        let posts = parsePosts(posts: hits)
        completion(posts, nil)
      } else {
        completion(nil, "Could not fetch posts")
      }
    }
    
    task.resume()
  }
}

private func parsePosts(posts: [[String: Any]]) -> [Post] {
  var result = [Post]()
  
  for post in posts {
    guard let title = post["title"] as? String,
      let points = post["points"] as? Int,
      let url = (post["url"] as? String) ?? (post["story_url"] as? String)
      else {
        continue
    }
    
    let post = Post(title: title, url: URL(string: url), points: points)
    result.append(post)
  }
  
  return result
}
