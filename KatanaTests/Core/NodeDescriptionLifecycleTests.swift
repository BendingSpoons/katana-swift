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
    return []
  }
  
  fileprivate static func didMount(props: TestStructProps, dispatch: StoreDispatch) {
    TestStruct.didMountInvoked?(props)
  }
}

class NodeDescriptionLifecycleTests: XCTestCase {
  func testNodeDidMount() {
   
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
}
