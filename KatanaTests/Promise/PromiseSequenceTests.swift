//
//  PromiseSequenceTests.swift
//  KatanaTests
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Quick
import Nimble
@testable import Katana

class PromiseSequenceTests: QuickSpec {
  
  override func spec() {
    describe("A sequence of promises") {
      context("when all its element resolves") {
        it("calls `then` closure") {
          
          let char = "A"
          let firstPromise: Promise<Int> = makePromise(named: "\(char)1", value: 1)
          let secondPromise: Promise<Int> = makePromise(named: "\(char)2", value: 2)
          let thirdPromise: Promise<Int> = makePromise(named: "\(char)3", value: 3)
          let fourthPromise: Promise<Int> = makePromise(named: "\(char)4", value: 4)
          let fifthPromise: Promise<Int> = makePromise(named: "\(char)5", value: 5)
          let sixthPromise: Promise<Int> = makePromise(named: "\(char)6", value: 6)
          
          let sequencePromise: Promise<[Int]> = all(firstPromise, secondPromise, thirdPromise, fourthPromise, fifthPromise, sixthPromise)
          
          var result = PromiseResult<[Int]>()
          waitPromise(sequencePromise, timeout: 10, completion: {
            result = $0
          })
          checkPromise(resolved: result, to: Array(1...6))
        }
      }

      context("when at least one element rejects") {
        it("calls `catch` closure") {
          
          let char = "B"
          let firstPromise: Promise<Int> = makePromise(named: "\(char)1", token: nil, value: 1)
          let secondPromise: Promise<Int> = makePromise(named: "\(char)2", token: nil, value: 2)
          let thirdPromise: Promise<Int> = makePromise(named: "\(char)3", token: nil, error: MockPromiseError.unknown)
          let fourthPromise: Promise<Int> = makePromise(named: "\(char)4", token: nil, value: 4)
          let fifthPromise: Promise<Int> = makePromise(named: "\(char)5", token: nil, value: 5)
          let sixthPromise: Promise<Int> = makePromise(named: "\(char)6", token: nil, value: 6)
          
          let sequencePromise: Promise<[Int]> = all(firstPromise, secondPromise, thirdPromise, fourthPromise, fifthPromise, sixthPromise)
          
          var result = PromiseResult<[Int]>()
          waitPromise(sequencePromise, timeout: 10, completion: {
            result = $0
          })
          checkPromise(rejected: result, with: MockPromiseError.unknown)
        }
      }
      
      context("when at least one element cancels its operation") {
        it("calls `cancel` closure") {
          
          let token = InvalidationToken()
          token.invalidate()
          
          let char = "C"
          let firstPromise: Promise<Int> = makePromise(named: "\(char)1", token: nil, value: 1)
          let secondPromise: Promise<Int> = makePromise(named: "\(char)2", token: nil, value: 2)
          let thirdPromise: Promise<Int> = makePromise(named: "\(char)3", token: token, value: 3)
          let fourthPromise: Promise<Int> = makePromise(named: "\(char)4", token: nil, value: 4)
          let fifthPromise: Promise<Int> = makePromise(named: "\(char)5", token: nil, value: 5)
          let sixthPromise: Promise<Int> = makePromise(named: "\(char)6", token: nil, value: 6)
          
          let sequencePromise: Promise<[Int]> = all(firstPromise, secondPromise, thirdPromise, fourthPromise, fifthPromise, sixthPromise)
          
          var result = PromiseResult<[Int]>()
          waitPromise(sequencePromise, timeout: 10, completion: {
            result = $0
          })
          checkPromise(cancelled: result)
        }
      }
    }
  }
}

