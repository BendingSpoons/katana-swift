//
//  CodingLoveState.swift
//  Katana
//
//  Created by Alain Caltieri on 07/11/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//
import Katana

struct CodingLoveState: State {
    var posts = [Post]()
    var page = 0
    var loading = false
    var allPostsFetched = false
}
