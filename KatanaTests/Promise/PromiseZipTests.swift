//
//  PromiseZipTests.swift
//  KatanaTests
//
//  Created by Alex Tosatto on 14/11/2018.
//

import Foundation
import Quick
import Nimble
@testable import Katana

typealias PromiseZipValue = (Int, String)
func == (lhs: PromiseZipValue, rhs: PromiseZipValue) -> Bool {
  return lhs.0 == rhs.0 && lhs.1 == rhs.1
}

class PromiseZipTests: QuickSpec {
  
  override func spec() {
    describe("A zip of promises") {
      context("when all its element resolves") {
        it("calls `then` closure") {
          
          let char = "A"
          let firstPromise: Promise<Int> = makePromise(named: "\(char)1", value: 1)
          let secondPromise: Promise<String> = makePromise(named: "\(char)2", value: "2")
          
          let zipPromise: Promise<PromiseZipValue> = Promise<PromiseZipValue>.zip(firstPromise, secondPromise)
          
          var result = PromiseResult<PromiseZipValue>()
          waitPromise(zipPromise, timeout: 10, completion: {
            result = $0
          })
          checkPromise(resolved: result)
          expect(result.value?.0).to(equal(1))
          expect(result.value?.1).to(equal("2"))
        }
      }
      
      context("when at least one element rejects") {
        it("calls `catch` closure") {

          let char = "B"
          let firstPromise: Promise<Int> = makePromise(named: "\(char)1", value: 1)
          let secondPromise: Promise<String> = makePromise(named: "\(char)2", error: MockPromiseError.unknown)
          
          let zipPromise: Promise<(Int, String)> = Promise<(Int, String)>.zip(firstPromise, secondPromise)
          
          var result = PromiseResult<(Int, String)>()
          waitPromise(zipPromise, timeout: 10, completion: {
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
          let firstPromise: Promise<Int> = makePromise(named: "\(char)1", token: token, value: 1)
          let secondPromise: Promise<String> = makePromise(named: "\(char)2", token: nil, value: "2")
          
          let zipPromise: Promise<(Int, String)> = Promise<(Int, String)>.zip(firstPromise, secondPromise)
          
          var result = PromiseResult<(Int, String)>()
          waitPromise(zipPromise, timeout: 10, completion: {
            result = $0
          })
          checkPromise(cancelled: result)
        }
      }
    }
  }
}

