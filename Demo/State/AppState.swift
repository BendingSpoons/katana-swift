//
//  AppState.swift
//  Katana
//
//  Created by Luca Querella on 24/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana


struct AppState : State {
  var pin: [Int]? = nil
  var instructionShown = false
  var photos: [String] = []
  var loadingPhotos = false
}
