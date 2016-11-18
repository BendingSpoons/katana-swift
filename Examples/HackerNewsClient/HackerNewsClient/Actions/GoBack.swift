//
//  GoBack.swift
//  HackerNewsClient
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Katana

struct GoBack: SyncAction {
    typealias Payload = ()
    var payload: Payload = ()
    
    static func updatedState(currentState: State, action: GoBack) -> State {
        var newState = currentState as! HackerNewsState
        newState.openPostURL = nil
        return newState
    }
}
