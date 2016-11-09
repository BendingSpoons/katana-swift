//
//  AnimationUtilsTests.swift
//  Katana
//
//  Created by Mauro Bolis on 09/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import XCTest
@testable import Katana

fileprivate struct TestDescription: AnyNodeDescription, Equatable {
  var frame: CGRect = .zero
  var key: String?
  var replaceKey: Int
  var payload: String
  var anyProps: AnyNodeDescriptionProps {
    return EmptyProps()
  }

  init(replaceKey: Int, payload: String) {
    self.replaceKey = replaceKey
    self.payload = payload
  }
  
  init(anyProps: AnyNodeDescriptionProps) {
    fatalError()
  }
  
  public func makeNode(parent: AnyNode) -> AnyNode {
    fatalError()
  }
  
  fileprivate func makeRoot(store: AnyStore?) -> Root {
    fatalError()
  }
  
  static func == (l: TestDescription, r: TestDescription) -> Bool {
    return l.replaceKey == r.replaceKey && l.payload == r.payload
  }
}

class AnimationUtilsTest: XCTestCase {
  func testMergeFirstStep() {
    let a = [
      TestDescription(replaceKey: "T".hashValue, payload: "10"),
      TestDescription(replaceKey: "Y".hashValue, payload: "10"),
      TestDescription(replaceKey: "K".hashValue, payload: "10"),
      TestDescription(replaceKey: "A".hashValue, payload: "10"),
      TestDescription(replaceKey: "W".hashValue, payload: "10"),
      TestDescription(replaceKey: "L".hashValue, payload: "10"),
      TestDescription(replaceKey: "Q".hashValue, payload: "10")
    ]
    
    let b = [
      TestDescription(replaceKey: "4".hashValue, payload: "20"),
      TestDescription(replaceKey: "L".hashValue, payload: "20"),
      TestDescription(replaceKey: "1".hashValue, payload: "20"),
      TestDescription(replaceKey: "T".hashValue, payload: "20"),
      TestDescription(replaceKey: "2".hashValue, payload: "20"),
      TestDescription(replaceKey: "K".hashValue, payload: "20"),
      TestDescription(replaceKey: "9".hashValue, payload: "20")
    ]
    
    let expected = [
      TestDescription(replaceKey: "4".hashValue, payload: "20"),
      TestDescription(replaceKey: "T".hashValue, payload: "10"),
      TestDescription(replaceKey: "Y".hashValue, payload: "10"),
      TestDescription(replaceKey: "K".hashValue, payload: "10"),
      TestDescription(replaceKey: "A".hashValue, payload: "10"),
      TestDescription(replaceKey: "W".hashValue, payload: "10"),
      TestDescription(replaceKey: "L".hashValue, payload: "10"),
      TestDescription(replaceKey: "1".hashValue, payload: "20"),
      TestDescription(replaceKey: "2".hashValue, payload: "20"),
      TestDescription(replaceKey: "9".hashValue, payload: "20"),
      TestDescription(replaceKey: "Q".hashValue, payload: "10"),
    ]
    
    let result = AnimationUtils.merge(descriptions: a, with: b, step: .firstIntermediate) as! [TestDescription]
    
    XCTAssertEqual(result, expected)
  }
  
  func testMergeSecondStep() {
    let a = [
      TestDescription(replaceKey: "T".hashValue, payload: "10"),
      TestDescription(replaceKey: "Y".hashValue, payload: "10"),
      TestDescription(replaceKey: "K".hashValue, payload: "10"),
      TestDescription(replaceKey: "A".hashValue, payload: "10"),
      TestDescription(replaceKey: "W".hashValue, payload: "10"),
      TestDescription(replaceKey: "L".hashValue, payload: "10"),
      TestDescription(replaceKey: "Q".hashValue, payload: "10")
    ]
    
    let b = [
      TestDescription(replaceKey: "4".hashValue, payload: "20"),
      TestDescription(replaceKey: "L".hashValue, payload: "20"),
      TestDescription(replaceKey: "1".hashValue, payload: "20"),
      TestDescription(replaceKey: "T".hashValue, payload: "20"),
      TestDescription(replaceKey: "2".hashValue, payload: "20"),
      TestDescription(replaceKey: "K".hashValue, payload: "20"),
      TestDescription(replaceKey: "9".hashValue, payload: "20")
    ]

    let expected = [
      TestDescription(replaceKey: "4".hashValue, payload: "20"),
      TestDescription(replaceKey: "L".hashValue, payload: "20"),
      TestDescription(replaceKey: "1".hashValue, payload: "20"),
      TestDescription(replaceKey: "T".hashValue, payload: "20"),
      TestDescription(replaceKey: "Y".hashValue, payload: "10"),
      TestDescription(replaceKey: "2".hashValue, payload: "20"),
      TestDescription(replaceKey: "K".hashValue, payload: "20"),
      TestDescription(replaceKey: "A".hashValue, payload: "10"),
      TestDescription(replaceKey: "W".hashValue, payload: "10"),
      TestDescription(replaceKey: "Q".hashValue, payload: "10"),
      TestDescription(replaceKey: "9".hashValue, payload: "20"),
    ]
    
    let result = AnimationUtils.merge(descriptions: a, with: b, step: .secondIntermediate) as! [TestDescription]
    
    XCTAssertEqual(result, expected)
  }
}
