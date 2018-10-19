//
//  StoreTests.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Quick
import Nimble
@testable import Katana

class StoreTest: QuickSpec {
  override func spec() {
    describe("The Store") {
      var store: Store<AppState>!
      
      beforeEach {
        store = Store<AppState>()
      }
      
      it("initializes the state as empty by default") {
        expect(store.state) == AppState()
      }
      
      // TODO:
      //  - supports state initializer
      //  - middleware, ...
      //  - put here "legacy" tests related to store per se
    }
  }
}
