//
//  Post.swift
//  HackerNewsClient
//
//  Created by Francesco Di Lorenzo on 15/11/2016.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

struct Post: Equatable {
    let title: String
    let url: URL?
    let points: Int
    
    public static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.title == rhs.title && lhs.url == rhs.url && lhs.points == rhs.points
    }
}
