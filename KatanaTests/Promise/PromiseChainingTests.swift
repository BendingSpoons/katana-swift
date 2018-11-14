//
//  PromiseChainingTests.swift
//  KatanaTests
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Quick
import Nimble
@testable import Katana

class PromiseChainingTests: QuickSpec {
  
  override func spec() {
    describe("A promise") {
      context("when has been chained to another promise") {
        it("calls `then` closure") {

          let char = "A"
          let firstPromise: Promise<Int> = makePromise(named: "\(char)1", value: 3)
          let secondPromise: Promise<String> = firstPromise.then({
            return makePromise(named: "\(char)2", value: "\($0)")
          })

          var result = PromiseResult<String>()
          waitPromise(secondPromise, timeout: 10, completion: {
            result = $0
          })
          checkPromise(resolved: result, to: "3")
        }
      }
      
      context("when has been chained to a cancelled promise") {
        it("calls `cancelled` closure") {

          let token = InvalidationToken()
          token.invalidate()

          let char = "B"
          let firstPromise: Promise<Int> = makePromise(named: "\(char)1", token: nil, value: 3)
          let secondPromise: Promise<String> = firstPromise.then({
            return makePromise(named: "\(char)2", token: token, value: "\($0)")
          })

          var result = PromiseResult<String>()
          waitPromise(secondPromise, timeout: 10, completion: {
            result = $0
          })
          checkPromise(cancelled: result)
        }
      }
      
      context("when has been cancelled before to be chained to another promise") {
        it("calls `cancelled` closure") {
          
          let token = InvalidationToken()
          token.invalidate()
          
          let char = "C"
          let firstPromise: Promise<Int> = makePromise(named: "\(char)1", token: token, value: 3)
          let secondPromise: Promise<String> = firstPromise.then({
            return makePromise(named: "\(char)2", value: "\($0)")
          })
          
          var result = PromiseResult<String>()
          waitPromise(secondPromise, timeout: 10, completion: {
            result = $0
          })
          checkPromise(cancelled: result)
        }
      }
      
      context("when resolves then invalidate the chained promise") {
        it("calls `cancelled` closure") {
          
          let token = InvalidationToken()
          
          let char = "D"
          let firstPromise: Promise<Int> = makePromise(named: "\(char)1", token: token, value: 3)
          let secondPromise: Promise<String> = firstPromise.then({
            token.invalidate()
            return makePromise(named: "\(char)2", token: token, value: "\($0)")
          })
          
          var result = PromiseResult<String>()
          waitPromise(secondPromise, timeout: 10, completion: {
            result = $0
          })
          checkPromise(cancelled: result)
        }
      }
      
      context("when has been chained to a promise that rejects") {
        it("calls `catch` closure") {
          
          let char = "E"
          let firstPromise: Promise<Int> = makePromise(named: "\(char)1", token: nil, value: 3)
          let secondPromise: Promise<String> = firstPromise.then({ _ in
            return makePromise(named: "\(char)2", token: nil, error: MockPromiseError.unknown)
          })
          
          var result = PromiseResult<String>()
          waitPromise(secondPromise, timeout: 10, completion: {
            result = $0
          })
          checkPromise(rejected: result, with: MockPromiseError.unknown)
        }
      }
      
      context("when has been rejected before to be chained to another promise") {
        it("calls `catch` closure") {
          
          let token = InvalidationToken()
          token.invalidate()
          
          let char = "F"
          let firstPromise: Promise<Int> = makePromise(named: "\(char)1", token: nil, error: MockPromiseError.unknown)
          let secondPromise: Promise<String> = firstPromise.then({
            return makePromise(named: "\(char)2", value: "\($0)")
          })
          
          var result = PromiseResult<String>()
          waitPromise(secondPromise, timeout: 10, completion: {
            result = $0
          })
          checkPromise(rejected: result, with: MockPromiseError.unknown)
        }
      }
    }
  }
}
