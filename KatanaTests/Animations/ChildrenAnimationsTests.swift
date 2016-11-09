//
//  ChildrenAnimationsTests.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import XCTest
@testable import Katana

class ChildrenAnimationsTests: XCTestCase {
  func testShouldAnimateEmpty() {
    let empty = ChildrenAnimations<Any>()
    XCTAssertEqual(empty.shouldAnimate, false)
  }
  
  func testNoAnimation() {
    enum TestKey { case testKey }
    var container = ChildrenAnimations<TestKey>()
    container[.testKey] = Animation(type: .none)
    XCTAssertEqual(container.shouldAnimate, false)
  }
  
  func testAnimation() {
    enum TestKey { case testKey }
    var container = ChildrenAnimations<TestKey>()
    container[.testKey] = Animation(type: .linear(duration: 0.3))
    XCTAssertEqual(container.shouldAnimate, true)
  }
  
  func testAllChildren() {
    enum TestKey { case testKey }
    var container = ChildrenAnimations<TestKey>()
    container.allChildren = Animation(type: .linear(duration: 0.3))
    
    let animation = container[.testKey]
    
    if case let .linear(value) = animation.type {
      XCTAssertEqual(value, 0.3)
    
    } else {
      XCTFail()
    }
  }
  
  func testShouldAnimateAllAnimation() {
    enum TestKey { case testKey }
    var container = ChildrenAnimations<TestKey>()
    container.allChildren = Animation(type: .linear(duration: 0.3))
    XCTAssertEqual(container.shouldAnimate, true)
  }
  
  func testShouldNotAnimateAllAnimation() {
    enum TestKey { case testKey }
    var container = ChildrenAnimations<TestKey>()
    container.allChildren = Animation(type: .none)
    XCTAssertEqual(container.shouldAnimate, false)
  }
  
  func testOverwriteAllChildren() {
    enum TestKey { case testKey, anotherKey }
    var container = ChildrenAnimations<TestKey>()
    
    container[.anotherKey] = Animation(type: .linear(duration: 0.4))
    container.allChildren = Animation(type: .linear(duration: 0.3))
    
    let animation = container[.testKey]
    let anotherAnimation = container[.anotherKey]
    
    if case let .linear(value) = animation.type {
      XCTAssertEqual(value, 0.3)
      
    } else {
      XCTFail()
    }
    
    if case let .linear(value) = anotherAnimation.type {
      XCTAssertEqual(value, 0.4)
      
    } else {
      XCTFail()
    }
  }

  func testMultipleSet() {
    enum TestKey { case testKey, anotherKey }
    var container = ChildrenAnimations<TestKey>()
    
    container[[.anotherKey, .testKey]] = Animation(type: .linear(duration: 0.4))
    
    let animation = container[.testKey]
    let anotherAnimation = container[.anotherKey]
    
    if case let .linear(value) = animation.type {
      XCTAssertEqual(value, 0.4)
      
    } else {
      XCTFail()
    }
    
    if case let .linear(value) = anotherAnimation.type {
      XCTAssertEqual(value, 0.4)
      
    } else {
      XCTFail()
    }
  }
}
