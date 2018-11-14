//
//  Promise+Utils.swift
//  KatanaTests
//
//  Created by Alex Tosatto on 14/11/2018.
//

import Foundation
import Nimble
@testable import Katana

enum MockPromiseError: Error {
  case unknown
}

struct PromiseResult<T> {
  let value: T?
  let error: Error?
  let cancelled: Bool
  
  init(value: T? = nil, error: Error? = nil, cancelled: Bool = false) {
    self.value = value
    self.error = error
    self.cancelled = cancelled
  }
}

func makePromise<T>(named name: String? = nil, in context: Context? = nil, token: InvalidationToken? = nil, value: T) -> Promise<T> {
  let promise = Promise<T>(in: context, token: token) { resolve, _, operation in
    if operation.isCancelled {
      operation.cancel()
      return
    }
    resolve(value)
  }
  promise.name = name
  return promise
}

func makePromise<T>(named name: String? = nil, in context: Context? = nil, token: InvalidationToken? = nil, error: Error) -> Promise<T> {
  let promise = Promise<T>(in: context, token: token) { _, reject, operation in
    if operation.isCancelled {
      operation.cancel()
      return
    }
    reject(error)
  }
  promise.name = name
  return promise
}

func waitPromise<T>(_ promise: Promise<T>, timeout: TimeInterval, completion: @escaping (PromiseResult<T>) -> ()) {
  waitUntil(timeout: timeout) { done in
    promise
      .then {
        done()
        completion(PromiseResult<T>(value: $0))
      }.catch {
        done()
        completion(PromiseResult<T>(error: $0))
      }.cancelled {
        done()
        completion(PromiseResult<T>(cancelled: true))
    }
  }
}

func checkPromise<T>(resolved result: PromiseResult<T>) {
  expect(result.value).toNot(beNil())
  expect(result.error).to(beNil())
  expect(result.cancelled).to(beFalse())
}

func checkPromise<T: Equatable>(resolved result: PromiseResult<T>, to value: T) {
  expect(result.value).to(equal(value))
  expect(result.error).to(beNil())
  expect(result.cancelled).to(beFalse())
}

func checkPromise<T>(rejected result: PromiseResult<T>, with error: Error) {
  expect(result.value).to(beNil())
  expect(result.error).toNot(beNil())
//  expect(result.error).to(beAKindOf(error))
  expect(result.cancelled).to(beFalse())
}

func checkPromise<T>(cancelled result: PromiseResult<T>) {
  expect(result.value).to(beNil())
  expect(result.error).to(beNil())
  expect(result.cancelled).to(beTrue())
}
