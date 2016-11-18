//
//  Post.swift
//  HackerNewsClient
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

struct Post: Equatable {
    let title: String
    let url: URL?
    let points: Int
    
    public static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.title == rhs.title && lhs.url == rhs.url && lhs.points == rhs.points
    }
}
