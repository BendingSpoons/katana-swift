//
//  AlbumModels.swift
//  ReKatana
//
//  Created by Mauro Bolis on 12/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

struct Album {
  let id: String
  let name: String
  let photos: [Photo] = []
}

struct Photo {
  let id: String
  let name: String
  let resolution: CGSize
}
