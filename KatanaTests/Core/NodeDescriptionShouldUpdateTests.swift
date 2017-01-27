//
//  NodeDescriptionShouldUpdateTests.swift
//  Katana
//
//  Created by Mauro Bolis on 18/01/2017.
//  Copyright © 2017 Bending Spoons. All rights reserved.
//

import Foundation
import Katana
import XCTest

fileprivate struct DescriptionProps: NodeDescriptionProps {
  var frame: CGRect = CGRect.zero
  var key: String?
  var alpha: CGFloat = 1.0
  
  var i: Int
  
  static func == (lhs: DescriptionProps, rhs: DescriptionProps) -> Bool {
    return lhs.frame == rhs.frame && lhs.i == rhs.i
  }
  
  init(i: Int) {
    self.i = i
  }
}

fileprivate struct Description: NodeDescription {
  static var invoked: (() -> ())? = nil
  typealias NativeView = TestView
  
  var props: DescriptionProps
  var children: [AnyNodeDescription] = []
  
  init(props: DescriptionProps) {
    self.props = props
  }
  
  public static func childrenDescriptions(props: DescriptionProps,
                                          state: EmptyState,
                                          update: @escaping (EmptyState) -> (),
                                          dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    
    Description.invoked?()
    return []
  }
}

fileprivate struct CustomDescription: NodeDescription {
  static var invoked: (() -> ())? = nil
  typealias NativeView = TestView
  
  var props: DescriptionProps
  var children: [AnyNodeDescription] = []
  
  init(props: DescriptionProps) {
    self.props = props
  }
  
  public static func childrenDescriptions(props: DescriptionProps,
                                          state: EmptyState,
                                          update: @escaping (EmptyState) -> (),
                                          dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    
    CustomDescription.invoked?()
    return []
  }
  
  public static func shouldUpdate(currentProps: DescriptionProps,
                                  nextProps: DescriptionProps,
                                  currentState: EmptyState,
                                  nextState: EmptyState) -> Bool {
    
    if nextProps.i == 999 {
      return false
    }
    
    return currentProps != nextProps
  }
}

class NodeDescriptionShouldUpdateTests: XCTestCase {
  func testDefaultBehaviour() {
    var invoked = false
    
    Description.invoked = {
      invoked = true
    }
    
    let renderer = Renderer(rootDescription: Description(props: DescriptionProps(i: 100)), store: nil)
    renderer.render(in: TestView())
    
    XCTAssert(invoked)
    
    // trigger an identical update
    invoked = false
    renderer.rootNode.update(with: Description(props: DescriptionProps(i: 100)))
    XCTAssertFalse(invoked)
    
    // trigger a different update
    invoked = false
    renderer.rootNode.update(with: Description(props: DescriptionProps(i: 99)))
    XCTAssert(invoked)
  }
  
  func testCustomUpdate() {
    var invoked = false
    
    CustomDescription.invoked = {
      invoked = true
    }
    
    let renderer = Renderer(rootDescription: CustomDescription(props: DescriptionProps(i: 100)), store: nil)
    renderer.render(in: TestView())
    
    XCTAssert(invoked)
    
    // trigger an identical update
    invoked = false
    renderer.rootNode.update(with: CustomDescription(props: DescriptionProps(i: 100)))
    XCTAssertFalse(invoked)
    
    // trigger a different update
    invoked = false
    renderer.rootNode.update(with: CustomDescription(props: DescriptionProps(i: 99)))
    XCTAssert(invoked)
    
    // trigger a 999 update
    invoked = false
    renderer.rootNode.update(with: CustomDescription(props: DescriptionProps(i: 999)))
    XCTAssertFalse(invoked)
  }
}
