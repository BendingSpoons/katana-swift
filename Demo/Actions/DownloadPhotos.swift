//
//  DownloadPhotos.swift
//  Katana
//
//  Created by Luca Querella on 29/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana

struct DownloadPhotos : AsyncAction {
  
  var loadingPayload: Void
  var completedPayload: [String]?
  var failedPayload: String?
  var state: AsyncActionState
  
  static func loadingReduce(state: inout AppState, action: DownloadPhotos) {
    state.loadingPhotos = true
  }
  
  static func failedReduce(state: inout AppState, action: DownloadPhotos) {
    state.loadingPhotos = false
  }
  
  static func completedReduce(state: inout AppState, action: DownloadPhotos) {
    state.loadingPhotos = false
    state.photos = action.completedPayload!
  }
  
  init(loadingPayload: Void) {
    self.state = .loading
  }
}
