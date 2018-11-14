//
//  PromiseTests.swift
//  KatanaTests
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Quick
import Nimble
@testable import Katana

class PromiseTests: QuickSpec {
  
  override func spec() {
    describe("A promise") {
      
      // MARK: - Success
      
      context("when has been resolved at initialization") {
        it("calls `then` closure") {
          
          let promise = Promise<Int>(resolved: 3)
          
          var result = PromiseResult<Int>()
          waitPromise(promise, timeout: 10, completion: {
            result = $0
          })
          checkPromise(resolved: result, to: 3)
        }
      }
      
      context("when has been resolved into the body") {
        it("calls `then` closure") {
          
          let promise = Promise<Int>({ resolve, _, _ in
            resolve(3)
          })
          
          var result = PromiseResult<Int>()
          waitPromise(promise, timeout: 10, completion: {
            result = $0
          })
          checkPromise(resolved: result, to: 3)
        }
      }
      
      // MARK: - Error
      
      context("when has been rejected at initialization") {
        it("calls `catch` closure") {
          
          let promise = Promise<Int>(rejected: MockPromiseError.unknown)
          
          var result = PromiseResult<Int>()
          waitPromise(promise, timeout: 10, completion: {
            result = $0
          })
          checkPromise(rejected: result, with: MockPromiseError.unknown)
        }
      }
      
      context("when has been rejected into the body") {
        it("calls `catch` closure") {
          
          let promise = Promise<Int>({ _, reject, _ in
            reject(MockPromiseError.unknown)
          })
          
          var result = PromiseResult<Int>()
          waitPromise(promise, timeout: 10, completion: {
            result = $0
          })
          checkPromise(rejected: result, with: MockPromiseError.unknown)
        }
      }
      
      // MARK: - Cancelled
      
      context("when has been cancelled") {
        it("calls `cancelled` closure") {
          
          let promise = Promise<Int>({ _, _, operation in
            operation.cancel()
          })
          
          var result = PromiseResult<Int>()
          waitPromise(promise, timeout: 10, completion: {
            result = $0
          })
          checkPromise(cancelled: result)
        }
      }
    }
    
    describe("A delayed promise") {
      context("when has been resolved") {
        it("calls `then` closure") {
          
          let promise: Promise<Int> = makePromise(value: 3, waitBeforeResolving: 5)
          
          var result = PromiseResult<Int>()
          waitPromise(promise, timeout: 10, completion: {
            result = $0
          })
          checkPromise(resolved: result, to: 3)
        }
      }
      
      context("when has been rejected") {
        it("calls `catch` closure") {
          
          let promise: Promise<Int> = makePromise(error: MockPromiseError.unknown, waitBeforeRejecting: 5)
          
          var result = PromiseResult<Int>()
          waitPromise(promise, timeout: 10, completion: {
            result = $0
          })
          checkPromise(rejected: result, with: MockPromiseError.unknown)
        }
      }
    }
  }
}
