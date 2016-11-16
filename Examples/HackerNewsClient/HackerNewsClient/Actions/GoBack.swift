//
//  GoBack.swift
//  HackerNewsClient
//
//  Created by Francesco Di Lorenzo on 15/11/2016.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Katana

struct GoBack: SyncAction {
    typealias Payload = Void
    var payload: Payload = ()
    
    static func updatedState(currentState: State, action: GoBack) -> State {
        var newState = currentState as! HackerNewsState
        newState.openPostURL = nil
        return newState
    }
}
