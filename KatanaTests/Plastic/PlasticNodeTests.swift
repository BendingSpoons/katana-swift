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
    /*let node = PlasticNode(description: TestNode(props: EmptyProps()), parent: nil, store: Store<EmptyReducer>())
    node.draw(container: UIView())
    
    XCTAssertEqual(TestNode.invoked, true)*/
  }
}


//FIXME

/*struct AppWithPlastic : NodeDescription, PlasticNodeDescription {
  typealias NativeView = UIView
  
  var props : AppProps
  var children: [AnyNodeDescription] = []
  
  static func render(props: AppProps,
                     state: EmptyState,
                     update: @escaping (EmptyState)->(),
                     dispatch: StoreDispatch) -> [AnyNodeDescription] {
    
    let i = props.i
    
    if (i == 0) {
      
      return [
        View(props: ViewProps().key(AppKeys.container).color(.gray)) {
          [
            Button(props: ButtonProps().key(AppKeys.button)
              .color(.orange, state: .normal)
              .color(.orange, state: .highlighted)
              .text("state \(i)", fontSize: 18)
              .onTap({ update(EmptyState()) })),
            
            View(props: ViewProps().key(AppKeys.otherView).color(.gray))
          ]
        }
      ]
      
    } else if (i == 1) {
      return [
        View(props: ViewProps().key(AppKeys.container).color(.gray)) {
          [
            Button(props: ButtonProps().key(AppKeys.button)
              .color(.orange, state: .normal)
              .color(.orange, state: .highlighted)
              .text("state \(i)", fontSize: 10)
              .onTap({ update(EmptyState()) }))
          ]
        }
      ]
      
    } else {
      return []
    }
  }

}

static func layout(views: ViewsContainer<AppKeys>, props: AppProps, state: EmptyState) -> Void {
    let container = views[.container]
    let button = views[.button]
    let otherView = views[.otherView]
    
    
    container?.size = .fixed(150, 150)
    button?.size = .fixed(150, 150)
    otherView?.size = .fixed(150, 150)
  }
}

func testNodeDeallocationPlastic() {
  let store = Store<EmptyReducer>()
  let root = AppWithPlastic(props: AppProps(i:0), children: []).node(store: store)
  var references = collectNodes(node: root.node).map { WeakNode(value: $0) }
  XCTAssert(references.count == 6)
  XCTAssert(references.filter { $0.value != nil }.count == 6)
  
  try! root.node.update(description: AppWithPlastic(props: AppProps(i:1), children: []))
  XCTAssert(references.count == 6)
  XCTAssertEqual(references.filter { $0.value != nil }.count, 5)
  
  references = collectNodes(node: root.node).map { WeakNode(value: $0) }
  XCTAssert(references.count == 5)
  XCTAssertEqual(references.filter { $0.value != nil }.count, 5)
  
  try! root.node.update(description: AppWithPlastic(props: AppProps(i:2), children: []))
  XCTAssert(references.count == 5)
  XCTAssertEqual(references.filter { $0.value != nil }.count, 0)
  
  references = collectNodes(node: root.node).map { WeakNode(value: $0) }
  XCTAssert(references.count == 0)
  XCTAssertEqual(references.filter { $0.value != nil }.count, 0)
}

func testViewDeallocationWithPlastic() {
  let store = Store<EmptyReducer>()
  let root = AppWithPlastic(props: AppProps(i:0), children: []).node(store : store)
  
  let rootVew = UIView()
  root.node.draw(container: rootVew)
  
  var references = collectView(view: rootVew)
    .filter { $0.tag ==  Katana.VIEW_TAG }
    .map { WeakView(value: $0) }
  
  autoreleasepool {
    try! root.node.update(description: AppWithPlastic(props: AppProps(i:2), children: []))
  }
  
  
  XCTAssertEqual(references.filter { $0.value != nil }.count, 1)
  
  references = collectView(view: rootVew)
    .filter { $0.tag ==  Katana.VIEW_TAG }
    .map { WeakView(value: $0) }
  
  XCTAssertEqual(references.count, 1)
}
 
*/
 
