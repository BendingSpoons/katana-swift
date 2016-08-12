//
//  AlbumListState.swift
//  ReKatana
//
//  Created by Mauro Bolis on 12/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

struct Album {
  let name: String
}

struct AlbumListState: State {
  let list: [Album]
}
