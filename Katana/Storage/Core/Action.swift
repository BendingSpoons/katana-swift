//
//  File.swift
//  ReKatana
//
//  Created by Mauro Bolis on 08/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

public protocol Action {
  var actionName: String { get }
}

// NB: internal usage only
struct InitAction: Action {
  let actionName = "@@INIT@@"
}

