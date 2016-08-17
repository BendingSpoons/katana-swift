//
//  File.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import XCTest
import Katana


private struct TestNode : NodeDescription {
  var props : EmptyProps
  var children: [AnyNodeDescription] = []
  
  static var initialState = EmptyState()
  static var viewType = UIView.self
  // since we are using a static var here we are not be able to
  // parallelize tests. Let's refactor this test when we will need it
  static var invoked: Bool = false
  
  static func render(props: EmptyProps,
                     state: EmptyState,
                     children: [AnyNodeDescription],
                     update: (EmptyState)->()) -> [AnyNodeDescription] {
    
    return [
      View(props: ViewProps().key("One"), children: [
        View(props: ViewProps().key("One-A")),
        View(props: ViewProps().key("One-B")),
        ]),
      View(props: ViewProps().key("Two")),
      View(props: ViewProps()),
      View(props: ViewProps().key("Four")),
    ]
  }
  
  static func layout(views: PlasticViewsContainer, props: EmptyProps, state: EmptyState) -> Void {
    self.invoked = true
  }
}


class PlasticNodeTests: XCTestCase {
  
  override func setUp() {
    TestNode.invoked = false
  }
  
  func testLayoutInvoked() {
    let node = Node(description: TestNode(props: EmptyProps(), children: []))
    let renderProfiler = RenderProfiler() { _ = $0 }
    node.render(container: renderProfiler)
    
    XCTAssertEqual(TestNode.invoked, true)
  }
}
