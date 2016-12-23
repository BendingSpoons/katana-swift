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
}

fileprivate struct TestStruct: NodeDescription {
  static var didMountInvoked: ((TestStructProps) -> ())? = nil
  
  fileprivate var props: TestStructProps
  
  fileprivate static func childrenDescriptions(props: TestStructProps,
                                               state: EmptyState,
                                               update: @escaping (EmptyState) -> (),
                                               dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    
    if props.testVariable > 100 {
      return [ InnerStruct(props: EmptyProps()) ]
    
    } else {
      return []
    }
  }
  
  fileprivate static func didMount(props: TestStructProps, dispatch: StoreDispatch) {
    TestStruct.didMountInvoked?(props)
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
}
