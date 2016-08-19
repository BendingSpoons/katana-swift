//
//  PlasticContainerTests.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import XCTest
@testable import Katana

class PlasticViewsContainerTests: XCTestCase {
  
  func testShouldCreateRootElement() {
    let hierarchy: [AnyNodeDescription] = []
    let rootFrame = CGRect(x: 0, y: 10, width: 20, height: 30)
    let plasticViewsContainer = ViewsContainer(rootFrame: rootFrame, children: hierarchy, multiplier: 1)
    
    let rootPlaceholder = plasticViewsContainer.rootView
    XCTAssertEqual(rootPlaceholder.frame, rootFrame)
  }
  
  func testShouldCreateChildren() {
    let hierarchy: [AnyNodeDescription] = [
      View(props: ViewProps().key("One")) {
        [
          View(props: ViewProps().key("One-A")),
          View(props: ViewProps().key("One-B")),
        ]
      },
      
      View(props: ViewProps().key("Two")),
      View(props: ViewProps()),
      View(props: ViewProps().key("Four")),
      ]
    
    
    let plasticViewsContainer = ViewsContainer(rootFrame: CGRect.zero, children: hierarchy, multiplier: 1)
    
    XCTAssertNotNil(plasticViewsContainer.rootView)
    XCTAssertNotNil(plasticViewsContainer["One"])
    XCTAssertNotNil(plasticViewsContainer["One-A"])
    XCTAssertNotNil(plasticViewsContainer["One-B"])
    XCTAssertNotNil(plasticViewsContainer["Two"])
    XCTAssertNotNil(plasticViewsContainer["Four"])
  }
  
  func testShouldKeepOriginalFrames() {
    
    let oneFrame = CGRect(x: 20, y: 30, width: 100, height: 100)
    let oneBFrame = CGRect(x: 10, y: 10, width: 10, height: 10)
    
    let hierarchy: [AnyNodeDescription] = [
      View(props: ViewProps().key("One").frame(oneFrame)) {
        [
          View(props: ViewProps().key("One-A")),
          View(props: ViewProps().key("One-B").frame(oneBFrame))
        ]
      },
      
      View(props: ViewProps().key("Two")),
      View(props: ViewProps()),
      View(props: ViewProps().key("Four")),
      ]
    
    
    let plasticViewsContainer = ViewsContainer(rootFrame: CGRect.zero, children: hierarchy, multiplier: 1)
    let onePlaceholder = plasticViewsContainer["One"]
    let oneBPlaceholder = plasticViewsContainer["One-B"]
    
    
    XCTAssertEqual(onePlaceholder?.frame, oneFrame)
    XCTAssertEqual(oneBPlaceholder?.frame, oneBFrame)
  }
  
  func testShouldManageHierarchy() {
    let hierarchy: [AnyNodeDescription] = [
      View(props: ViewProps().key("One")) {
        [
          View(props: ViewProps().key("One-A")) {
            [
              View(props: ViewProps().key("One-A-Inner")),
            ]
          }
        ]
      }
    ]
    
    
    let containerFrame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    let plasticViewsContainer = ViewsContainer(rootFrame: containerFrame, children: hierarchy, multiplier: 1)
    
    // add some initial positions
    let viewOne = plasticViewsContainer["One"]!
    let viewOneA = plasticViewsContainer["One-A"]!
    let viewOneAInner = plasticViewsContainer["One-A-Inner"]!
    let root = plasticViewsContainer.rootView
    
    viewOne.coverRight(root)
    viewOne.width = .fixed(400)
    
    viewOneA.asHeader(viewOne)
    viewOneA.height = .fixed(300)
    
    viewOneAInner.asFooter(viewOneA)
    viewOneAInner.height = .fixed(100)
    
    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: "One-A-Inner"),
      100 - viewOneA.absoluteOrigin.x
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: "One-A-Inner"),
      100 - viewOneA.absoluteOrigin.y
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: "One-A"),
      100 - viewOne.absoluteOrigin.x
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: "One-A"),
      100 - viewOne.absoluteOrigin.y
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: "One"),
      100 - root.absoluteOrigin.x
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: "One"),
      100 - root.absoluteOrigin.y
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: root.key),
      100
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: root.key),
      100
    )
  }


  func testShouldManageHierarchyWithoutKeys() {
    
    let oneAFrame = CGRect(x: 10, y: 10, width: 200, height: 200)
    
    let hierarchy: [AnyNodeDescription] = [
      View(props: ViewProps().key("One")) {
        [
          View(props: ViewProps().frame(oneAFrame)) {
            [
              View(props: ViewProps().key("One-A-Inner"))
            ]
          }
        ]
      }
    ]
    
    let containerFrame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    let plasticViewsContainer = ViewsContainer(rootFrame: containerFrame, children: hierarchy, multiplier: 1)
    
    // add some initial positions
    let viewOne = plasticViewsContainer["One"]!
    let viewOneAInner = plasticViewsContainer["One-A-Inner"]!
    let root = plasticViewsContainer.rootView
    
    viewOne.coverRight(root)
    viewOne.width = .fixed(400)
    
    viewOneAInner.asFooter(viewOne)
    viewOneAInner.height = .fixed(100)
    
    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: "One"),
      100 - root.absoluteOrigin.x
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: "One"),
      100 - root.absoluteOrigin.y
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(600, inCoordinateSystemOfParentOfKey: "One-A-Inner"),
      -10
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(900, inCoordinateSystemOfParentOfKey: "One-A-Inner"),
      890
    )
  }
}
