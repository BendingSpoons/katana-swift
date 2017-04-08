//
//  StateMockProviderTests.swift
//  Katana
//
//  Created by Mauro Bolis on 02/04/2017.
//  Copyright © 2017 Bending Spoons. All rights reserved.
//

import Foundation
import XCTest
@testable import Katana

fileprivate struct CustomState: NodeDescriptionState {
  let int: Int
  
  init(int: Int) {
    self.int = int
  }
  
  init() {
    self.int = 99
  }
  
  static func == (l: CustomState, r: CustomState) -> Bool {
    return l.int == r.int
  }
}

fileprivate struct CustomProps: NodeDescriptionProps {
  var frame: CGRect = CGRect.zero
  var key: String?
  var alpha: CGFloat = 1.0
  
  var i: Int
  
  init(i: Int) {
    self.i = i
  }
}

fileprivate struct CustomDescription: NodeDescription {
  typealias NativeView = TestView
  typealias StateType = CustomState
  typealias PropsType = CustomProps
  
  var props: PropsType
  
  init(props: PropsType) {
    self.props = props
  }
  
  public static func childrenDescriptions(props: PropsType,
                                          state: StateType,
                                          update: @escaping (StateType) -> (),
                                          dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    
    return []
  }
}

class StateMockProviderTests: XCTestCase {
  func testBase() {
    let provider = StateMockProvider()
    
    provider.mockState(CustomState(int: 101), for: CustomDescription.self, passing: {
      return $0.i == 1000
    })
    
    let state = provider.state(for: CustomDescription.self, props: CustomProps(i: 1000))
    XCTAssertEqual(state, CustomState(int: 101))
  }
  
  func testNotFound() {
    let provider = StateMockProvider()
    
    provider.mockState(CustomState(int: 101), for: CustomDescription.self, passing: {
      return $0.i == 90
    })
    
    let state = provider.state(for: CustomDescription.self, props: CustomProps(i: 1000))
    XCTAssertNil(state)
  }
  
  func testTakeFirst() {
    let provider = StateMockProvider()
    
    provider.mockState(CustomState(int: 100), for: CustomDescription.self, passing: {
      return $0.i == 101
    })
    
    provider.mockState(CustomState(int: 99), for: CustomDescription.self, passing: {
      return $0.i == 101
    })
    
    let state = provider.state(for: CustomDescription.self, props: CustomProps(i: 101))
    XCTAssertEqual(state, CustomState(int: 100))
  }
}
