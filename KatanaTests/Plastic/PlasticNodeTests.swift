//
//  File.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import XCTest
@testable import Katana
import KatanaElements

class PlasticNodeTests: XCTestCase {
  override func setUp() {
    TestNode.invoked = false
  }
  
  func testLayoutInvoked() {
    let root = TestNode(props: EmptyProps()).makeRoot(store: nil)
    root.draw(in: UIView())
    
    XCTAssertEqual(TestNode.invoked, true)
  }
  
  func testNodeDeallocationPlastic() {
    let root = App(props: AppProps(i:0), children: []).makeRoot(store: nil)
    
  
    var references = collectNodes(node: root.node!).map { WeakNode(value: $0) }
    XCTAssert(references.count == 6)
    XCTAssert(references.filter { $0.value != nil }.count == 6)
    
    try! root.node!.update(with: App(props: AppProps(i:1), children: []))
    XCTAssert(references.count == 6)
    XCTAssertEqual(references.filter { $0.value != nil }.count, 5)
    
    references = collectNodes(node: root.node!).map { WeakNode(value: $0) }
    XCTAssert(references.count == 5)
    XCTAssertEqual(references.filter { $0.value != nil }.count, 5)
    
    try! root.node!.update(with: App(props: AppProps(i:2), children: []))
    XCTAssert(references.count == 5)
    XCTAssertEqual(references.filter { $0.value != nil }.count, 0)
    
    references = collectNodes(node: root.node!).map { WeakNode(value: $0) }
    XCTAssert(references.count == 0)
    XCTAssertEqual(references.filter { $0.value != nil }.count, 0)
  }
  
  func testViewDeallocationWithPlastic() {

    let root = App(props: AppProps(i:0), children: []).makeRoot(store: nil)
    
    let rootVew = UIView()
    root.draw(in: rootVew)
    
    var references = collectView(view: rootVew)
      .filter { $0.tag ==  Katana.VIEWTAG }
      .map { WeakView(value: $0) }
    
    autoreleasepool {
      try! root.node!.update(with: App(props: AppProps(i:2), children: []))
    }
    
    
    XCTAssertEqual(references.filter { $0.value != nil }.count, 1)
    
    references = collectView(view: rootVew)
      .filter { $0.tag ==  Katana.VIEWTAG }
      .map { WeakView(value: $0) }
    
    XCTAssertEqual(references.count, 1)
  }
  
  
}


private enum Keys {
  case One
}

private struct TestNode: NodeDescription, PlasticNodeDescription {


  typealias NativeView = UIView
  
  var props: EmptyProps
  
  // since we are using a static var here we are not be able to
  // parallelize tests. Let's refactor this test when we will need it
  static var invoked: Bool = false
  
  public static func childrenDescriptions(props: EmptyProps,
                            state: EmptyState,
                            update: @escaping (EmptyState) -> (),
                            dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
   
    
    return [
      View(props: ViewProps().key(Keys.One))
    ]
  }
  
  static func layout(views: ViewsContainer<Keys>, props: EmptyProps, state: EmptyState) -> Void {
    self.invoked = true
  }
}

fileprivate struct MyAppState: State {}

fileprivate struct AppProps: NodeProps {
  var frame: CGRect = CGRect.zero
  var i: Int
  
  static func == (lhs: AppProps, rhs: AppProps) -> Bool {
    return lhs.frame == rhs.frame && lhs.i == rhs.i
  }
  
  init(i: Int) {
    self.i = i
  }
}

fileprivate struct App: NodeDescription {
  
  var props: AppProps
  var children: [AnyNodeDescription] = []
  
  
  fileprivate static func childrenDescriptions(props: AppProps,
                                 state: EmptyState,
                                 update: @escaping (EmptyState) -> (),
                                 dispatch:  @escaping StoreDispatch) -> [AnyNodeDescription] {

    
    
    let i = props.i
    
    if i == 0 {
      
      return [
        View(props: ViewProps()
          .frame(0, 0, 150, 150)
          .color(.gray)
          .key(AppKeys.container)
        ) {
          [
            Button(props: ButtonProps()
              .key(AppKeys.button)
              .frame(50, 50, 100, 100)
              .color(.orange, state: .normal)
              .color(.orange, state: .highlighted)
              .text("state \(i)", fontSize: 10)
              .onTap({ update(EmptyState()) })
            ),
            
            View(props: ViewProps()
              .frame(0, 0, 150, 150)
              .color(.gray)
              .key(AppKeys.otherView)
              
            )
          ]
        }
      ]
      
    } else if i == 1 {
      return [
        View(props: ViewProps()
          .frame(0, 0, 150, 150)
          .color(.gray)
          .key(AppKeys.container)
        ) {
          [
            Button(props: ButtonProps()
              .frame(50, 50, 100, 100)
              .key(AppKeys.button)
              .color(.orange, state: .normal)
              .color(.orange, state: .highlighted)
              .text("state \(i)", fontSize: 10)
              .onTap({ update(EmptyState()) })
            )
          ]
        }
      ]
      
    } else {
      return []
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

fileprivate enum AppKeys {
  case container, button, otherView
}


fileprivate class WeakNode {
  weak var value: AnyNode?
  init(value: AnyNode) {
    self.value = value
  }
}

fileprivate class WeakView {
  weak var value: UIView?
  init(value: UIView) {
    self.value = value
  }
}

fileprivate func collectNodes(node: AnyNode) -> [AnyNode] {
  return (node.children.map { collectNodes(node: $0) }.reduce([], { $0 + $1 })) + node.children
}

fileprivate func collectView(view: UIView) -> [UIView] {
  return (view.subviews.map { collectView(view: $0) }.reduce([], { $0 + $1 })) + view.subviews
}
