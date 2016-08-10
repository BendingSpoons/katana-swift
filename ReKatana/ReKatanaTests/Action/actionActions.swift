//
//  actions.swift
//  ReKatana
//
//  Created by Mauro Bolis on 10/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation
@testable import ReKatana

enum AsyncActions {
  typealias LoginActionType = AsyncAction<String, Int, Float>
  static let LoginAction = AsyncActionCreator<String, Int, Float>(withName: "LoginAction")
}


enum SyncActions {
  typealias LogoutActionType = SyncAction<String>
  static let LogoutAction = SyncActionCreator<String>(withName: "LogoutAction")
}
