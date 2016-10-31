//
//  dependencyContainer.swift
//  Katana
//
//  Created by Mauro Bolis on 31/10/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import Katana

class SimpleDependencyContainer: SideEffectDependencyContainer {
  let state: AppState?
  
  public required init(state: State, dispatch: @escaping StoreDispatch) {
    if let s = state as? AppState {
      self.state = s
    
    } else {
      self.state = nil
    }
  }
}
