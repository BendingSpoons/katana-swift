//
//  PlasticContainerTests.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import XCTest
@testable import Katana

private enum Keys {
  case One, OneA, OneB, OneAInner
  case Two
  case Four
}

class PlasticViewsContainerTests: XCTestCase {
  
  func testShouldCreateRootElement() {
    let hierarchy: [AnyNodeDescription] = []
    let rootFrame = CGRect(x: 0, y: 10, width: 20, height: 30)
    let plasticViewsContainer = ViewsContainer<Keys>(nativeViewFrame: rootFrame, childrenDescriptions: hierarchy, multiplier: 1)
    
    let rootPlaceholder = plasticViewsContainer.nativeView
    XCTAssertEqual(rootPlaceholder.frame, rootFrame)
  }
  
  func testShouldCreateChildren() {
    let hierarchy: [AnyNodeDescription] = [
      View(props: ViewProps(Keys.One)) {
        [
          View(props: ViewProps(Keys.OneA)),
          View(props: ViewProps(Keys.OneB)),
        ]
      },
      
      View(props: ViewProps(Keys.Two)),
      View(props: ViewProps()),
      View(props: ViewProps(Keys.Four)),
    ]
    
    
    let plasticViewsContainer = ViewsContainer<Keys>(nativeViewFrame: CGRect.zero, childrenDescriptions: hierarchy, multiplier: 1)
    plasticViewsContainer.initialize()
    
    XCTAssertNotNil(plasticViewsContainer.nativeView)
    XCTAssertNotNil(plasticViewsContainer[.One])
    XCTAssertNotNil(plasticViewsContainer[.OneA])
    XCTAssertNotNil(plasticViewsContainer[.OneB])
    XCTAssertNotNil(plasticViewsContainer[.Two])
    XCTAssertNotNil(plasticViewsContainer[.Four])
  }
  
  func testShouldKeepOriginalFrames() {
    
    let oneFrame = CGRect(x: 20, y: 30, width: 100, height: 100)
    let oneBFrame = CGRect(x: 10, y: 10, width: 10, height: 10)
    
    let hierarchy: [AnyNodeDescription] = [
      View(props: ViewProps(Keys.One, frame: oneFrame)) {
        [
          View(props: ViewProps(Keys.OneA)),
          View(props: ViewProps(Keys.OneB, frame: oneBFrame))
        ]
      },
      
      View(props: ViewProps(Keys.Two)),
      View(props: ViewProps()),
      View(props: ViewProps(Keys.Four)),
    ]
    
    
    let plasticViewsContainer = ViewsContainer<Keys>(nativeViewFrame: CGRect.zero, childrenDescriptions: hierarchy, multiplier: 1)
    plasticViewsContainer.initialize()
    let onePlaceholder = plasticViewsContainer[Keys.One]
    let oneBPlaceholder = plasticViewsContainer[Keys.OneB]
    
    
    XCTAssertEqual(onePlaceholder?.frame, oneFrame)
    XCTAssertEqual(oneBPlaceholder?.frame, oneBFrame)
  }
  
  func testShouldManageHierarchy() {
    let hierarchy: [AnyNodeDescription] = [
      View(props: ViewProps(Keys.One)) {
        [
          View(props: ViewProps(Keys.OneA)) {
            [
              View(props: ViewProps(Keys.OneAInner)),
            ]
          }
        ]
      }
    ]
    
    
    let containerFrame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    
    let plasticViewsContainer = ViewsContainer<Keys>(
      nativeViewFrame: containerFrame,
      childrenDescriptions: hierarchy,
      multiplier: 1
    )
    
    plasticViewsContainer.initialize()
    
    // add some initial positions
    let viewOne = plasticViewsContainer[Keys.One]!
    let viewOneA = plasticViewsContainer[Keys.OneA]!
    let viewOneAInner = plasticViewsContainer[Keys.OneAInner]!
    let root = plasticViewsContainer.nativeView
    
    viewOne.coverRight(root)
    viewOne.width = .fixed(400)
    
    viewOneA.asHeader(viewOne)
    viewOneA.height = .fixed(300)
    
    viewOneAInner.asFooter(viewOneA)
    viewOneAInner.height = .fixed(100)
    
    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.OneAInner)"),
      100 - viewOneA.absoluteOrigin.x
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.OneAInner)"),
      100 - viewOneA.absoluteOrigin.y
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.OneA)"),
      100 - viewOne.absoluteOrigin.x
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.OneA)"),
      100 - viewOne.absoluteOrigin.y
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.One)"),
      100 - root.absoluteOrigin.x
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.One)"),
      100 - root.absoluteOrigin.y
    )
  }
  
  func testShouldManageHierarchyWithNonZeroRootOrigin() {
    let hierarchy: [AnyNodeDescription] = [
      View(props: ViewProps(Keys.One)) {
        [
          View(props: ViewProps(Keys.OneA)) {
            [
              View(props: ViewProps(Keys.OneAInner)),
            ]
          }
        ]
      }
    ]
    
    
    let containerFrame = CGRect(x: 20, y: 20, width: 1000, height: 1000)
    
    let plasticViewsContainer = ViewsContainer<Keys>(
      nativeViewFrame: containerFrame,
      childrenDescriptions: hierarchy,
      multiplier: 1
    )
    
    plasticViewsContainer.initialize()
    
    // add some initial positions
    let viewOne = plasticViewsContainer[Keys.One]!
    let viewOneA = plasticViewsContainer[Keys.OneA]!
    let viewOneAInner = plasticViewsContainer[Keys.OneAInner]!
    let root = plasticViewsContainer.nativeView
    
    viewOne.coverRight(root)
    viewOne.width = .fixed(400)
    
    viewOneA.asHeader(viewOne)
    viewOneA.height = .fixed(300)
    
    viewOneAInner.asFooter(viewOneA)
    viewOneAInner.height = .fixed(100)
    
    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.OneAInner)"),
      100 - viewOneA.absoluteOrigin.x
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.OneAInner)"),
      100 - viewOneA.absoluteOrigin.y
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.OneA)"),
      100 - viewOne.absoluteOrigin.x
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.OneA)"),
      100 - viewOne.absoluteOrigin.y
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.One)"),
      100 - root.absoluteOrigin.x
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.One)"),
      100 - root.absoluteOrigin.y
    )
  }
  
  
  func testShouldManageHierarchyWithoutKeys() {
    
    let oneAFrame = CGRect(x: 10, y: 10, width: 200, height: 200)
    
    let hierarchy: [AnyNodeDescription] = [
      View(props: ViewProps(Keys.One)) {
        [
          View(props: ViewProps(oneAFrame)) {
            [
              View(props: ViewProps(Keys.OneAInner))
            ]
          }
        ]
      }
    ]
    
    let containerFrame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    let plasticViewsContainer = ViewsContainer<Keys>(nativeViewFrame: containerFrame,
                                                     childrenDescriptions: hierarchy,
                                                     multiplier: 1)
    plasticViewsContainer.initialize()
    
    // add some initial positions
    let viewOne = plasticViewsContainer[Keys.One]!
    let viewOneAInner = plasticViewsContainer[Keys.OneAInner]!
    let root = plasticViewsContainer.nativeView
    
    viewOne.coverRight(root)
    viewOne.width = .fixed(400)
    
    viewOneAInner.asFooter(viewOne)
    viewOneAInner.height = .fixed(100)
    
    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.One)"),
      100 - root.absoluteOrigin.x
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.One)"),
      100 - root.absoluteOrigin.y
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(600, inCoordinateSystemOfParentOfKey: "\(Keys.OneAInner)"),
      -10
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(900, inCoordinateSystemOfParentOfKey: "\(Keys.OneAInner)"),
      890
    )
  }
}
