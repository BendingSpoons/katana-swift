//
//  CancelComplexPromiseTests.swift
//  KatanaTests
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Quick
import Nimble
@testable import Katana

class CancelComplexPromiseTests: QuickSpec {
  override func spec() {
    describe("A complex promise") {
      
      context("when has been resolved") {
        it("calls `then` closure") {
          print("[Promise Test]")
          let promise: Promise<Bool> = complexPromise()
          var result = PromiseResult<Bool>()
          waitPromise(promise, timeout: 10, completion: {
            result = $0
          })
          checkPromise(resolved: result, to: false)
        }
      }

      context("when has been cancelled on int promise creation") {
        it("calls `cancel` closure") {
          print("[Promise Test]")
          let token = InvalidationToken()
          let promise: Promise<Bool> = complexPromise(
            token: token,
            willMakeIntPromise: { i in
              guard i == 2 else { return }
              print("[Promise Test] *** invalidating token")
              token.invalidate()
          })
          var result = PromiseResult<Bool>()
          waitPromise(promise, timeout: 10, completion: {
            result = $0
          })
          checkPromise(cancelled: result)
        }
      }

      context("when has been cancelled on string promise creation") {
        it("calls `cancel` closure") {
          print("[Promise Test]")
          let token = InvalidationToken()
          let promise: Promise<Bool> = complexPromise(
            token: token,
            willMakeStringPromise: { s in
              guard s == "5" else { return }
              print("[Promise Test] *** invalidating token")
              token.invalidate()
          })
          var result = PromiseResult<Bool>()
          waitPromise(promise, timeout: 10, completion: {
            result = $0
          })
          checkPromise(cancelled: result)
        }
      }

      context("when has been cancelled on bool promise creation") {
        it("calls `cancel` closure") {
          print("[Promise Test]")
          let token = InvalidationToken()
          let promise: Promise<Bool> = complexPromise(
            token: token,
            willMakeBoolPromise: {
              print("[Promise Test] *** invalidating token")
              token.invalidate()
          })
          var result = PromiseResult<Bool>()
          waitPromise(promise, timeout: 10, completion: {
            result = $0
          })
          checkPromise(cancelled: result)
        }
      }
    }
  }
}

fileprivate func complexPromise(
  token: InvalidationToken? = nil,
  willMakeIntPromise: ((Int) -> ())? = nil,
  willMakeStringPromise: ((String) -> ())? = nil,
  willMakeBoolPromise: (() -> ())? = nil) -> Promise<Bool> {
  
  let firstPromises: [Promise<Int>] = Array(1...3).map { i in
    let whatever: String = "" // cannot be an Int
    return makePromise(value: whatever, waitBeforeResolving: 0.5).then({ _ in
      willMakeIntPromise?(i)
      let promise = makePromise(token: token, value: i)
      promise.then { _ in
        print("[Promise Test] Int promise \(i) resolved")
        }.cancelled {
          print("[Promise Test] Int promise \(i) cancelled")
      }
      return promise
    })
  }
  
  let firstPromise: Promise<[Int]> = all(firstPromises)
  
  firstPromise.then { _ in
    print("[Promise Test] All int promise resolved")
    }.cancelled {
      print("[Promise Test] All int promise cancelled")
  }
  
  let secondPromises: [Promise<String>] = Array(1...5).map { "\($0)" }.map { s in
    let whatever: Int = 0 // cannot be a String
    return makePromise(value: whatever, waitBeforeResolving: 0.5).then({ _ in
      willMakeStringPromise?(s)
      let promise = makePromise(token: token, value: s)
      promise.then { _ in
        print("[Promise Test] String promise \(s) resolved")
        }.cancelled {
          print("[Promise Test] String promise \(s) cancelled")
      }
      return promise
    })
  }
  
  let secondPromise: Promise<[String]> = all(secondPromises)
  
  secondPromise.then { _ in
    print("[Promise Test] All string promise resolved")
    }.cancelled {
      print("[Promise Test] All string promise cancelled")
  }
  
  let zipPromise = Promise<([Int], [String])>.zip(firstPromise, secondPromise)
  
  zipPromise.then { _ in
    print("[Promise Test] Zip promise resolved")
    }.cancelled {
      print("[Promise Test] Zip promise cancelled")
  }
  
  return zipPromise.then({ zipped in
    willMakeBoolPromise?()
    let promise = Promise<Bool>(token: token, { resolve, _, operation in
      if operation.isCancelled {
        operation.cancel()
        return
      }
      resolve(zipped.0.count == zipped.1.count)
    })
    promise.then { _ in
      print("[Promise Test] Bool promise resolved")
      }.cancelled {
        print("[Promise Test] Bool promise cancelled")
    }
    return promise
  })
}
