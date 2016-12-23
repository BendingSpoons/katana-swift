//
//  NodeDescriptionLifecycleTests.swift
//  Katana
//
//  Created by Mauro Bolis on 23/12/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import XCTest
import Katana


fileprivate struct InnerStruct: NodeDescription {
  static var didMountInvoked: (() -> ())? = nil
  static var didUnmountInvoked: (() -> ())? = nil
  
  fileprivate var props: EmptyProps
  
  fileprivate static func childrenDescriptions(props: EmptyProps,
                                               state: EmptyState,
                                               update: @escaping (EmptyState) -> (),
                                               dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    return []
  }
  
  fileprivate static func didMount(props: EmptyProps, dispatch: StoreDispatch) {
    InnerStruct.didMountInvoked?()
  }
  
  fileprivate static func didUnmount(props: EmptyProps, dispatch: StoreDispatch) {
    InnerStruct.didUnmountInvoked?()
  }
}


fileprivate struct TestStructProps: NodeDescriptionProps {
  fileprivate var alpha: CGFloat = 1.0
  fileprivate var key: String?
  fileprivate var frame: CGRect = .zero
  fileprivate var testVariable: Int
  
  fileprivate init(testVariable: Int) {
    self.testVariable = testVariable
  }
  
  fileprivate static func == (l: TestStructProps, r: TestStructProps) -> Bool {
    return l.testVariable == r.testVariable
  }
}

fileprivate struct TestStructState: NodeDescriptionState {
  var state: Int = 0
  
  fileprivate static func == (l: TestStructState, r: TestStructState) -> Bool {
    return l.state == r.state
  }
}

fileprivate struct TestStruct: NodeDescription {
  static var didMountInvoked: ((TestStructProps) -> ())? = nil
  static var willReceivePropsInvoked: ((TestStructProps, TestStructProps) -> ())? = nil
  static var states: [Int] = []
  
  fileprivate var props: TestStructProps
  
  fileprivate static func childrenDescriptions(props: TestStructProps,
                                               state: TestStructState,
                                               update: @escaping (TestStructState) -> (),
                                               dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    
    // just for testing.. don't do this stuff in real applications
    TestStruct.states.append(state.state)
    
    if props.testVariable > 100 {
      return [ InnerStruct(props: EmptyProps()) ]
    
    } else {
      return []
    }
  }
  
  fileprivate static func didMount(props: TestStructProps, dispatch: StoreDispatch) {
    TestStruct.didMountInvoked?(props)
  }
  
  fileprivate static func descriptionWillReceiveProps(state: TestStructState,
                                                      currentProps: TestStructProps,
                                                      nextProps: TestStructProps,
                                                      dispatch: StoreDispatch,
                                                      update: (TestStructState) -> ()) {
    
    update(TestStructState(state: nextProps.testVariable))
    TestStruct.willReceivePropsInvoked?(currentProps, nextProps)
  }
}

class NodeDescriptionLifecycleTests: XCTestCase {
  func testBasicNodeDidMount() {
    var invokedProps: TestStructProps?
    var invoked: Bool = false
    
    TestStruct.didMountInvoked = {
      invokedProps = $0
      invoked = true
    }
    
    let renderer = Renderer(rootDescription: TestStruct(props: TestStructProps(testVariable: 100)), store: nil)
    renderer.render(in: TestView())
    
    XCTAssertTrue(invoked)
    XCTAssertEqual(invokedProps?.testVariable, 100)
  }
  
  func testInnerNodeDidMount() {
    
    var testStructInvokedProps: TestStructProps?
    var testStructInvoked: Bool = false
    var innerStructInvoked: Bool = false
    
    TestStruct.didMountInvoked = {
      testStructInvokedProps = $0
      testStructInvoked = true
    }
    
    InnerStruct.didMountInvoked = {
      innerStructInvoked = true
    }
    
    let renderer = Renderer(rootDescription: TestStruct(props: TestStructProps(testVariable: 101)), store: nil)
    renderer.render(in: TestView())
    
    XCTAssertTrue(testStructInvoked)
    XCTAssertTrue(innerStructInvoked)
    XCTAssertEqual(testStructInvokedProps?.testVariable, 101)
  }
  
  func testDidUnMount() {
    var testStructInvokedProps: TestStructProps?
    var testStructMountInvoked: Bool = false
    var innerStructMountInvoked: Bool = false
    var innerStructUnmountInvoked: Bool = false
    
    TestStruct.didMountInvoked = {
      testStructInvokedProps = $0
      testStructMountInvoked = true
    }
    
    InnerStruct.didMountInvoked = {
      innerStructMountInvoked = true
    }
    
    InnerStruct.didUnmountInvoked = {
      innerStructUnmountInvoked = true
    }
    
    let renderer = Renderer(rootDescription: TestStruct(props: TestStructProps(testVariable: 200)), store: nil)
    renderer.render(in: TestView())
    
    XCTAssertTrue(testStructMountInvoked)
    XCTAssertTrue(innerStructMountInvoked)
    XCTAssertFalse(innerStructUnmountInvoked)
    XCTAssertEqual(testStructInvokedProps?.testVariable, 200)
    
    renderer.rootNode.update(with: TestStruct(props: TestStructProps(testVariable: 50)))
    XCTAssertTrue(testStructMountInvoked)
    XCTAssertTrue(innerStructMountInvoked)
    XCTAssertTrue(innerStructUnmountInvoked)
    XCTAssertEqual(testStructInvokedProps?.testVariable, 200) // this should not be invoked again
  }
  
  func testWillReceiveProps() {
    var willReceiveCurrentProps: TestStructProps?
    var willReceiveNextProps: TestStructProps?
    var willReceiveInvoked: Bool = false
    
    TestStruct.states = []
    
    TestStruct.willReceivePropsInvoked = { curr, next in
      willReceiveInvoked = true
      willReceiveCurrentProps = curr
      willReceiveNextProps = next
    }
    
    let renderer = Renderer(rootDescription: TestStruct(props: TestStructProps(testVariable: 200)), store: nil)
    renderer.render(in: TestView())
    
    XCTAssertFalse(willReceiveInvoked)
    XCTAssertEqual(TestStruct.states, [0])
    
    renderer.rootNode.update(with: TestStruct(props: TestStructProps(testVariable: 50)))
    
    XCTAssertTrue(willReceiveInvoked)
    XCTAssertEqual(willReceiveCurrentProps?.testVariable, 200)
    XCTAssertEqual(willReceiveNextProps?.testVariable, 50)
    XCTAssertEqual(TestStruct.states, [0, 50]) // also checks that the childrenDescriptions is invoked the proper number of times
  }
}
