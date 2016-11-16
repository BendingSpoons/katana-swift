//
//  OpenPost.swift
//  HackerNewsClient
//
//  Created by Francesco Di Lorenzo on 15/11/2016.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Katana

struct OpenPost: SyncAction {
    
    typealias Payload = URL
    
    var payload: URL
    
    init(payload: Payload) {
        self.payload = payload
    }
    
    static func updatedState(currentState: State, action: OpenPost) -> State {
        var newState = currentState as! HackerNewsState
        newState.openPostURL = action.payload
        return newState
    }
}
