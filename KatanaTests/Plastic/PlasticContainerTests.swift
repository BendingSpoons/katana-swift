//
//  PlasticContainerTests.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import XCTest
@testable import Katana

private enum Keys {
  case one, oneA, oneB, oneAInner
  case two
  case four
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
      View(props: ViewProps(Keys.one)) {
        [
          View(props: ViewProps(Keys.oneA)),
          View(props: ViewProps(Keys.oneB))
        ]
      },

      View(props: ViewProps(Keys.two)),
      View(props: ViewProps()),
      View(props: ViewProps(Keys.four))
    ]

    let plasticViewsContainer = ViewsContainer<Keys>(nativeViewFrame: CGRect.zero, childrenDescriptions: hierarchy, multiplier: 1)
    plasticViewsContainer.initialize()

    XCTAssertNotNil(plasticViewsContainer.nativeView)
    XCTAssertNotNil(plasticViewsContainer[.one])
    XCTAssertNotNil(plasticViewsContainer[.oneA])
    XCTAssertNotNil(plasticViewsContainer[.oneB])
    XCTAssertNotNil(plasticViewsContainer[.two])
    XCTAssertNotNil(plasticViewsContainer[.four])
  }

  func testShouldKeepOriginalFrames() {

    let oneFrame = CGRect(x: 20, y: 30, width: 100, height: 100)
    let oneBFrame = CGRect(x: 10, y: 10, width: 10, height: 10)

    let hierarchy: [AnyNodeDescription] = [
      View(props: ViewProps(Keys.one, frame: oneFrame)) {
        [
          View(props: ViewProps(Keys.oneA)),
          View(props: ViewProps(Keys.oneB, frame: oneBFrame))
        ]
      },

      View(props: ViewProps(Keys.two)),
      View(props: ViewProps()),
      View(props: ViewProps(Keys.four))
    ]

    let plasticViewsContainer = ViewsContainer<Keys>(nativeViewFrame: CGRect.zero, childrenDescriptions: hierarchy, multiplier: 1)
    plasticViewsContainer.initialize()
    let onePlaceholder = plasticViewsContainer[Keys.one]
    let oneBPlaceholder = plasticViewsContainer[Keys.oneB]

    XCTAssertEqual(onePlaceholder?.frame, oneFrame)
    XCTAssertEqual(oneBPlaceholder?.frame, oneBFrame)
  }

  func testShouldManageHierarchy() {
    let hierarchy: [AnyNodeDescription] = [
      View(props: ViewProps(Keys.one)) {
        [
          View(props: ViewProps(Keys.oneA)) {
            [
              View(props: ViewProps(Keys.oneAInner))
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
    let viewOne = plasticViewsContainer[Keys.one]!
    let viewOneA = plasticViewsContainer[Keys.oneA]!
    let viewOneAInner = plasticViewsContainer[Keys.oneAInner]!
    let root = plasticViewsContainer.nativeView

    viewOne.coverRight(root)
    viewOne.width = .fixed(400)

    viewOneA.asHeader(viewOne)
    viewOneA.height = .fixed(300)

    viewOneAInner.asFooter(viewOneA)
    viewOneAInner.height = .fixed(100)

    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.oneAInner)"),
      100 - viewOneA.absoluteOrigin.x
    )

    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.oneAInner)"),
      100 - viewOneA.absoluteOrigin.y
    )

    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.oneA)"),
      100 - viewOne.absoluteOrigin.x
    )

    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.oneA)"),
      100 - viewOne.absoluteOrigin.y
    )

    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.one)"),
      100 - root.absoluteOrigin.x
    )

    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.one)"),
      100 - root.absoluteOrigin.y
    )
  }

  func testShouldManageHierarchyWithNonZeroRootOrigin() {
    let hierarchy: [AnyNodeDescription] = [
      View(props: ViewProps(Keys.one)) {
        [
          View(props: ViewProps(Keys.oneA)) {
            [
              View(props: ViewProps(Keys.oneAInner))
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
    let viewOne = plasticViewsContainer[Keys.one]!
    let viewOneA = plasticViewsContainer[Keys.oneA]!
    let viewOneAInner = plasticViewsContainer[Keys.oneAInner]!
    let root = plasticViewsContainer.nativeView

    viewOne.coverRight(root)
    viewOne.width = .fixed(400)

    viewOneA.asHeader(viewOne)
    viewOneA.height = .fixed(300)

    viewOneAInner.asFooter(viewOneA)
    viewOneAInner.height = .fixed(100)

    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.oneAInner)"),
      100 - viewOneA.absoluteOrigin.x
    )

    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.oneAInner)"),
      100 - viewOneA.absoluteOrigin.y
    )

    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.oneA)"),
      100 - viewOne.absoluteOrigin.x
    )

    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.oneA)"),
      100 - viewOne.absoluteOrigin.y
    )

    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.one)"),
      100 - root.absoluteOrigin.x
    )

    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.one)"),
      100 - root.absoluteOrigin.y
    )
  }

  func testShouldManageHierarchyWithoutKeys() {

    let oneAFrame = CGRect(x: 10, y: 10, width: 200, height: 200)

    let hierarchy: [AnyNodeDescription] = [
      View(props: ViewProps(Keys.one)) {
        [
          View(props: ViewProps(oneAFrame)) {
            [
              View(props: ViewProps(Keys.oneAInner))
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
    let viewOne = plasticViewsContainer[Keys.one]!
    let viewOneAInner = plasticViewsContainer[Keys.oneAInner]!
    let root = plasticViewsContainer.nativeView

    viewOne.coverRight(root)
    viewOne.width = .fixed(400)

    viewOneAInner.asFooter(viewOne)
    viewOneAInner.height = .fixed(100)

    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.one)"),
      100 - root.absoluteOrigin.x
    )

    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: "\(Keys.one)"),
      100 - root.absoluteOrigin.y
    )

    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(600, inCoordinateSystemOfParentOfKey: "\(Keys.oneAInner)"),
      -10
    )

    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(900, inCoordinateSystemOfParentOfKey: "\(Keys.oneAInner)"),
      890
    )
  }
}
