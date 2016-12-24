//
//  PlasticConvenienceLayoutTests.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

// swiftlint:disable type_body_length

import Foundation
import XCTest
@testable import Katana

class PlasticConvenienceLayoutTests: XCTestCase {
  private let CALCULATIONACCURACY: CGFloat = 0.01

  func testShouldFillViewHorizontally() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    // no margin
    v1.fillHorizontally(v2)
    XCTAssertEqual(v1.left.coordinate, v2.left.coordinate)
    XCTAssertEqual(v1.right.coordinate, v2.right.coordinate)

    // with insets
    v1.fillHorizontally(v2, insets: .fixed(0, 10, 0, 10))
    XCTAssertEqual(v1.frame.origin.x, v2.frame.origin.x + 10)
    XCTAssertEqual(v1.frame.size.width, v2.frame.size.width - 20)

    // scalable insets
    v1.fillHorizontally(v2, insets: .scalable(0, 10, 0, 10))
    XCTAssertEqualWithAccuracy(v1.frame.origin.x, v2.frame.origin.x + 10 * multiplier, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.width, v2.frame.size.width - 20 * multiplier, accuracy: CALCULATIONACCURACY)

    // negative insets
    v1.fillHorizontally(v2, insets: .fixed(0, -10, 0, -10))
    XCTAssertEqual(v1.frame.origin.x, v2.frame.origin.x - 10)
    XCTAssertEqual(v1.frame.size.width, v2.frame.size.width + 20)
  }

  func testShouldFillViewVertically() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    // no margin
    v1.fillVertically(v2)
    XCTAssertEqual(v1.top.coordinate, v2.top.coordinate)
    XCTAssertEqual(v1.bottom.coordinate, v2.bottom.coordinate)

    // with insets
    v1.fillVertically(v2, insets: .fixed(10, 0, 10, 0))
    XCTAssertEqualWithAccuracy(v1.frame.origin.y, v2.frame.origin.y + 10, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.height, v2.frame.size.height - 20, accuracy: CALCULATIONACCURACY)

    // scalable insets
    v1.fillVertically(v2, insets: .scalable(10, 0, 10, 0))
    XCTAssertEqualWithAccuracy(v1.frame.origin.y, v2.frame.origin.y + 10 * multiplier, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.height, v2.frame.size.height - 20 * multiplier, accuracy: CALCULATIONACCURACY)

    // negative insets
    v1.fillVertically(v2, insets: .fixed(-10, 0, -10, 0))
    XCTAssertEqualWithAccuracy(v1.frame.origin.y, v2.frame.origin.y - 10, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.height, v2.frame.size.height + 20, accuracy: CALCULATIONACCURACY)
  }

  func testShouldFillView() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    // no margin
    v1.fill(v2)
    XCTAssertEqual(v1.frame, v2.frame)

    // with insets
    v1.fill(v2, insets: .fixed(10, 10, 10, 10))
    XCTAssertEqualWithAccuracy(v1.frame.origin.x, v2.frame.origin.x + 10, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.origin.y, v2.frame.origin.y + 10, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.height, v2.frame.size.height - 20, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.width, v2.frame.size.width - 20, accuracy: CALCULATIONACCURACY)

    // scalable insets
    v1.fill(v2, insets: .scalable(10, 10, 10, 10))
    XCTAssertEqualWithAccuracy(v1.frame.origin.x, v2.frame.origin.x + 10 * multiplier, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.origin.y, v2.frame.origin.y + 10 * multiplier, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.height, v2.frame.size.height - 20 * multiplier, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.width, v2.frame.size.width - 20 * multiplier, accuracy: CALCULATIONACCURACY)

    // negative insets
    v1.fill(v2, insets: .fixed(-10, -10, -10, -10))
    XCTAssertEqualWithAccuracy(v1.frame.origin.x, v2.frame.origin.x - 10, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.origin.y, v2.frame.origin.y - 10, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.height, v2.frame.size.height + 20, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.width, v2.frame.size.width + 20, accuracy: CALCULATIONACCURACY)
  }

  func testShouldFitView() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    // no margins
    v1.fit(v2)
    XCTAssertEqual(v1.frame, v2.frame)

    // with aspectRatio
    v1.fit(v2, aspectRatio: 0.5)
    XCTAssertEqualWithAccuracy(v1.frame.origin.x,
                               v2.frame.origin.x + v2.size.width.fixed/4,
                               accuracy: CALCULATIONACCURACY)
    XCTAssertEqual(v1.frame.origin.y, v2.frame.origin.y)
    XCTAssertEqualWithAccuracy(v1.frame.size.width,
                               v2.frame.size.width / 2,
                               accuracy: CALCULATIONACCURACY)
    XCTAssertEqual(v1.frame.size.height, v2.frame.size.height)

    // with fixed insets & aspectRatio
    v1.fit(v2, aspectRatio: 0.5, insets: .fixed(10, 10, 10, 10))

    let newHeight = v2.height.unscaledValue - 10*2
    let newWidth = newHeight / 2

    XCTAssertEqualWithAccuracy(v1.frame.origin.x,
                               v2.frame.origin.x + (v2.frame.size.width - newWidth)/2,
                               accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.origin.y,
                               v2.frame.origin.y + 10,
                               accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.height,
                               newHeight,
                               accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.width,
                               newWidth,
                               accuracy: CALCULATIONACCURACY)
  }

  func testShouldCenterBetweenLeftAndRight() {
    /*
     x
     +----------------------------------->
     |
     |
     |                          +------+
     |  +--------  ----------+  |      |
     |  |       |  |         |  |      |
     |  |   v2  |  |   v1    |  |      |
     |  |       |  |         |  |  v3  |
     |  +--------  ----------+  |      |
     |                          |      |
     |                          +------+
     y v
     
     
     When we center v2 between two anchors we have that the origin.x of v2 will be the origin of the left anchor 
     // plus half of the space between the two anchors
     
     */
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 50, height: 50)
    let v2RightX = v2Frame.origin.x + v2Frame.size.width
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    let v3Frame = CGRect(x: 400, y: 50, width: 50, height: 50)
    let v3 = PlasticView(hierarchyManager: hM, key: "C", multiplier: multiplier, frame: v3Frame)

    v1.centerBetween(left: v2.right, right: v3.left)
    XCTAssertEqual(v1.frame.origin.x, v2RightX + (v3.frame.origin.x - v2RightX) / 2.0)
  }

  func testShouldCenterBetweenTopAndBottom() {
    /*
     x
     +----------------------------------->
     |          +-------------------+
     |          |        v1         |
     |          +-------------------+
     |
     |          +-------------------+
     |          |        v2         |
     |          +-------------------+
     |
     |          +-------------------+
     |          |        v3         |
     y v          +-------------------+
     
     
     
     When we center v2 between two anchors we have that the origin.y of v2 will be the origin of the top anchor 
     plus half of the space between the two anchors
     */
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 50, height: 50)
    let v2BottomY = v2Frame.origin.y + v2Frame.size.height
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    let v3Frame = CGRect(x: 400, y: 50, width: 50, height: 50)
    let v3 = PlasticView(hierarchyManager: hM, key: "C", multiplier: multiplier, frame: v3Frame)

    v1.centerBetween(top: v2.bottom, bottom: v3.top)
    XCTAssertEqual(v1.frame.origin.y, v2BottomY + (v3.frame.origin.y - v2BottomY) / 2.0)
  }

  func testShouldCenterInView() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)
    // we need to provide a size in order to calculate the center
    v1.size = .fixed(100, 100)

    let v2Frame = CGRect(x: 20, y: 50, width: 50, height: 50)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    v1.center(v2)

    let v1Center = CGPoint(x: v1.frame.origin.x + v1.frame.size.width / 2.0, y: v1.frame.origin.y + v1.frame.size.height / 2.0)
    let v2Center = CGPoint(x: v2.frame.origin.x + v2.frame.size.width / 2.0, y: v2.frame.origin.y + v2.frame.size.height / 2.0)
    XCTAssertEqual(v1Center, v2Center)
  }

  func testShouldCoverLeft() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 50, height: 50)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    // no insets
    v1.coverLeft(v2)
    XCTAssertEqual(v1.frame.origin, v2.frame.origin)
    XCTAssertEqualWithAccuracy(v1.frame.size.height, v2.frame.size.height, accuracy: CALCULATIONACCURACY)

    // fixed insets
    v1.coverLeft(v2, insets: .fixed(10, 10, 10, 0))
    XCTAssertEqualWithAccuracy(v1.frame.origin.x, v2.frame.origin.x + 10, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.origin.y, v2.frame.origin.y + 10, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.height, v2.frame.size.height - 20, accuracy: CALCULATIONACCURACY)

    // scalable insets
    v1.coverLeft(v2, insets: .scalable(10, 10, 10, 0))
    XCTAssertEqualWithAccuracy(v1.frame.origin.x, v2.frame.origin.x + 10 * multiplier, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.origin.y, v2.frame.origin.y + 10 * multiplier, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.height, v2.frame.size.height - 20 * multiplier, accuracy: CALCULATIONACCURACY)

    // negative insets
    v1.coverLeft(v2, insets: .fixed(-10, -10, -10, 0))
    XCTAssertEqualWithAccuracy(v1.frame.origin.x, v2.frame.origin.x - 10, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.origin.y, v2.frame.origin.y - 10, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.height, v2.frame.size.height + 20, accuracy: CALCULATIONACCURACY)
  }

  func testShouldCoverRight() {

    /*
     x
     +----------------------------------->
     |
     |    +--------------------------+
     |    |                 +--------|
     |    |                 |       ||
     |    |                 |       ||
     |    |      v2         |   v1  ||
     |    |                 |       ||
     |    |                 |       ||
     |    |                 +--------|
     |    +--------------------------+
     y v
     
     When we cover right v1 with respect to v2 we need to calculate the origin of v1.
     In order to calculate it we need to calculate the right corner of v2, which is v1.origin.x + v1.origin.width.
     At this point we subtract the width of v1
     The y coordinate is just the same
     */

    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)
    // here we need to define the width otherwise plastic won't be able to calculate the origin
    //(To be honest it works anyway, but it resolves the origin when the width is set.
    //We set it upfront since we are in a testing environment)
    v1.width = .fixed(50)

    let v2Frame = CGRect(x: 20, y: 50, width: 500, height: 50)
    let v2RightPoint = v2Frame.origin.x + v2Frame.size.width
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    // no insets
    v1.coverRight(v2)
    XCTAssertEqualWithAccuracy(v1.frame.origin.x, v2RightPoint - v1.frame.size.width, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.origin.y, v2.frame.origin.y, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.height, v2.frame.size.height, accuracy: CALCULATIONACCURACY)

    // fixed insets
    v1.coverRight(v2, insets: .fixed(20, 0, 10, 50))
    XCTAssertEqualWithAccuracy(v1.frame.origin.x, v2RightPoint - v1.frame.size.width - 50, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.origin.y, v2.frame.origin.y + 20, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.height, v2.frame.size.height - 30, accuracy: CALCULATIONACCURACY)

    // scalable insets
    v1.coverRight(v2, insets: .scalable(20, 0, 10, 50))
    XCTAssertEqualWithAccuracy(v1.frame.origin.x,
                               v2RightPoint - v1.frame.size.width - 50 * multiplier,
                               accuracy: CALCULATIONACCURACY)

    XCTAssertEqualWithAccuracy(v1.frame.origin.y, v2.frame.origin.y + 20 * multiplier, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.height, v2.frame.size.height - 30 * multiplier, accuracy: CALCULATIONACCURACY)

    // negative insets
    v1.coverRight(v2, insets: .fixed(-20, 0, -10, -50))
    XCTAssertEqualWithAccuracy(v1.frame.origin.x, v2RightPoint - v1.frame.size.width + 50, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.origin.y, v2.frame.origin.y - 20, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.height, v2.frame.size.height + 30, accuracy: CALCULATIONACCURACY)
  }

  func testShouldSetAsHeader() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 50, height: 50)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    // no insets
    v1.asHeader(v2)
    XCTAssertEqual(v1.frame.origin, v2.frame.origin)
    XCTAssertEqualWithAccuracy(v1.frame.size.width, v2.frame.size.width, accuracy: CALCULATIONACCURACY)

    // fixed insets
    v1.asHeader(v2, insets: .fixed(10, 10, 0, 10))
    XCTAssertEqualWithAccuracy(v1.frame.origin.x, v2.frame.origin.x + 10, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.origin.y, v2.frame.origin.y + 10, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.width, v2.frame.size.width - 20, accuracy: CALCULATIONACCURACY)

    // scalable insets
    v1.asHeader(v2, insets: .scalable(10, 10, 0, 10))
    XCTAssertEqualWithAccuracy(v1.frame.origin.x, v2.frame.origin.x + 10 * multiplier, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.origin.y, v2.frame.origin.y + 10 * multiplier, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.width, v2.frame.size.width - 20 * multiplier, accuracy: CALCULATIONACCURACY)

    // negative insets
    v1.asHeader(v2, insets: .fixed(-10, -10, 0, -10))
    XCTAssertEqualWithAccuracy(v1.frame.origin.x, v2.frame.origin.x - 10, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.origin.y, v2.frame.origin.y - 10, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.width, v2.frame.size.width + 20, accuracy: CALCULATIONACCURACY)
  }

  func testShouldSetAsFooter() {
    /*
     x
     +----------------------------------->
     |
     |    +--------------------------+
     |    |                          |
     |    |           v1             |
     |    |                          |
     |    |                          |
     |    +--------------------------+
     |    ||           v2           ||
     |    |--------------------------|
     |    +--------------------------+
     y v
     
     
     When we set v1 as footer with respect to v2 we need to calculate the origin of v1.
     In order to calculate it we need to calculate the bottom corner of v2, which is v1.origin.y + v1.origin.height.
     At this point we subtract the height of v1
     
     The x coordinate is just the same
     */
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)
    // here we need to define the height otherwise plastic won't be able to calculate the origin
    // (To be honest it works anyway, but it resolves the origin when the width is set.
    // We set it upfront since we are in a testing environment)
    v1.height = .fixed(50)

    let v2Frame = CGRect(x: 20, y: 50, width: 500, height: 50)
    let v2BottomPoint = v2Frame.origin.y + v2Frame.size.height
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    // no insets
    v1.asFooter(v2)
    XCTAssertEqual(v1.frame.origin.y, v2BottomPoint - v1.frame.size.height)
    XCTAssertEqual(v1.frame.origin.x, v2.frame.origin.x)
    XCTAssertEqual(v1.frame.size.width, v2.frame.size.width)

    // fixed insets
    v1.asFooter(v2, insets: .fixed(0, 30, 10, 50))
    XCTAssertEqualWithAccuracy(v1.frame.origin.y, v2BottomPoint - v1.frame.size.height - 10, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.origin.x, v2.frame.origin.x + 30, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.width, v2.frame.size.width - 80, accuracy: CALCULATIONACCURACY)

    // scalable insets
    v1.asFooter(v2, insets: .scalable(0, 30, 10, 50))
    XCTAssertEqualWithAccuracy(v1.frame.origin.y,
                               v2BottomPoint - v1.frame.size.height - 10 * multiplier,
                               accuracy: CALCULATIONACCURACY)

    XCTAssertEqualWithAccuracy(v1.frame.origin.x, v2.frame.origin.x + 30 * multiplier, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.width, v2.frame.size.width - 80 * multiplier, accuracy: CALCULATIONACCURACY)

    // negative insets
    v1.asFooter(v2, insets: .fixed(0, -30, -10, -50))
    XCTAssertEqualWithAccuracy(v1.frame.origin.y, v2BottomPoint - v1.frame.size.height + 10, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.origin.x, v2.frame.origin.x - 30, accuracy: CALCULATIONACCURACY)
    XCTAssertEqualWithAccuracy(v1.frame.size.width, v2.frame.size.width + 80, accuracy: CALCULATIONACCURACY)
  }
}
