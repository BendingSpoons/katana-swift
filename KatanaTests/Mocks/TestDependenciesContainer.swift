//
//  TestDependenciesContainer.swift
//  KatanaTests
//
//  Created by Mauro Bolis on 21/10/2018.
//

import Foundation
import Katana

final class TestDependenciesContainer: SideEffectDependencyContainer {
  
  
  func delay(of interval: TimeInterval) -> Promise<Void> {
    return Promise { resolve, reject, _ in
      DispatchQueue.global().asyncAfter(deadline: .now() + interval, execute: resolve)
    }
  }
  
  
  init(dispatch: @escaping StoreDispatch, getState: @escaping () -> State) {
    
  }
}
