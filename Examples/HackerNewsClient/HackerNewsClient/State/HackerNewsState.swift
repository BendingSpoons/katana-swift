//
//  HackerNewsState.swift
//  HackerNewsClient
//
//  Created by Francesco Di Lorenzo on 15/11/2016.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Katana

struct HackerNewsState: State {
    var posts = [Post]()
    var loading = false
    var openPostURL: URL?
}
