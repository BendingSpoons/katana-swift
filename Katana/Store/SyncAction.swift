//
//  SyncAction.swift
//  Katana
//
//  Created by Mauro Bolis on 28/10/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public protocol SyncAction: Action {
  associatedtype Payload
  var payload: Payload { get }
}
