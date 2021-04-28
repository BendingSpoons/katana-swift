//
//  XCTestCase+Promise.swift
//  Katana
//
//  Copyright © 2021 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Hydra
import XCTest

extension XCTestCase {
  func waitForPromise<T>(_ promise: Promise<T>) -> T {
    var promiseResult: T!
    let expectation = XCTestExpectation(description: "Promise completed")
    promise.then(in: .main) { result in
      promiseResult = result
      expectation.fulfill()
    }
    self.wait(for: [expectation], timeout: 10)
    return promiseResult
  }

  func waitForPromises<T>(_ promises: Promise<T>...) {
    let expectations: [XCTestExpectation] = promises.map { promise in
      let expectation = XCTestExpectation(description: "Promise completed")
      promise.then(in: .main) { _ in expectation.fulfill() }
      return expectation
    }
    self.wait(for: expectations, timeout: 10)
  }

  func waitFor(_ predicate: @escaping () -> Bool) {
    let expectation = XCTestExpectation(description: "Predicate satisfied")
    DispatchQueue.global().async {
      while !predicate() {
        // wait
      }
      expectation.fulfill()
    }
    self.wait(for: [expectation], timeout: 10)
  }
}
