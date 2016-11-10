//
//  CodingLoveState.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.


import Katana

struct CodingLoveState: State {
    var posts = [Post]()
    var loading = false
    var allPostsFetched = false
    
    var page = 0
}
