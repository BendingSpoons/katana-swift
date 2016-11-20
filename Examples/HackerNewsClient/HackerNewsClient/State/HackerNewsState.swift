//
//  HackerNewsState.swift
//  HackerNewsClient
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Katana

struct HackerNewsState: State {
  var posts = [Post]()
  var loading = false
  var openPostURL: URL?
}
