//
//  ChildrenAnimationsTests.swift
//  Katana
//
//  Created by Mauro Bolis on 09/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import XCTest
@testable import Katana

class ChildrenAnimationsTests: XCTestCase {
  func testShouldAnimateEmpty() {
    let empty = ChildrenAnimations<Any>()
    XCTAssertEqual(empty.shouldAnimate, false)
  }
  
  func testShouldAnimateAddNoAnimation() {
    enum TestKey { case testKey }
    var empty = ChildrenAnimations<TestKey>()
    empty[.testKey] = Animation(type: .none)
    XCTAssertEqual(empty.shouldAnimate, false)
  }
  
  func testShouldAnimateAddAnimation() {
    enum TestKey { case testKey }
    var empty = ChildrenAnimations<TestKey>()
    empty[.testKey] = Animation(type: .linear(duration: 0.3))
    XCTAssertEqual(empty.shouldAnimate, true)
  }
}
