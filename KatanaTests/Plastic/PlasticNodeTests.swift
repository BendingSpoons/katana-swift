//
//  File.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import XCTest
import Katana

private enum Keys: String, NodeDescriptionKeys {
  case One
}

private struct TestNode : NodeDescription, PlasticNodeDescription {
  typealias NativeView = UIView

  var props : EmptyProps
  
  static var initialState = EmptyState()
  // since we are using a static var here we are not be able to
  // parallelize tests. Let's refactor this test when we will need it
  static var invoked: Bool = false
  
  static func render(props: EmptyProps,
                     state: EmptyState,
                     update: @escaping (EmptyState)->(),
                     dispatch: StoreDispatch) -> [AnyNodeDescription] {
    
    return [
      View(props: ViewProps().key(Keys.One))
    ]
  }
  
  static func layout(views: ViewsContainer<Keys>, props: EmptyProps, state: EmptyState) -> Void {
    self.invoked = true
  }
}


class PlasticNodeTests: XCTestCase {
  override func setUp() {
    TestNode.invoked = false
  }
  
  func testLayoutInvoked() {
    let node = PlasticNode(description: TestNode(props: EmptyProps()), parentNode: nil, store: Store<EmptyReducer>())
    node.draw(container: UIView())
    
    XCTAssertEqual(TestNode.invoked, true)
  }
}
