//
//  PlasticBasicLayoutTests.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import XCTest
@testable import Katana

//swiftlint:disable type_body_length

class PlasticBasicLayoutTests: XCTestCase {
  func testShouldAssignHeight() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    // fixed
    v1.height = .fixed(300)
    XCTAssertEqual(v1.frame.size.height, 300)

    // scalable
    v1.height = .scalable(300)
    XCTAssertEqual(v1.frame.size.height, 300 * multiplier)

    // from another view
    v1.height = v2.height
    XCTAssertEqual(v1.frame.size.height, v2Frame.size.height)
  }

  func testShouldAssignHeightFromTopAndBottom() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    v1.top = v2.top
    v1.bottom = v2.bottom
    XCTAssertEqual(v1.frame.size.height, v2.frame.size.height)
  }

  func testShouldAssignHeightFromBottomAndTop() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    v1.bottom = v2.bottom
    v1.top = v2.top
    XCTAssertEqual(v1.frame.size.height, v2.frame.size.height)
  }

  func testShouldAssignHeightFromCenterYAndBottom() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    v1.centerY = v2.centerY
    v1.bottom = v2.bottom
    XCTAssertEqual(v1.frame.size.height, v2.frame.size.height)
  }

  func testShouldAssignHeightFromBottomAndCenterY() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    v1.bottom = v2.bottom
    v1.centerY = v2.centerY
    XCTAssertEqual(v1.frame.size.height, v2.frame.size.height)
  }

  func testShouldAssignHeightFromTopAndCenterY() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    v1.top = v2.top
    v1.centerY = v2.centerY
    XCTAssertEqual(v1.frame.size.height, v2.frame.size.height)
  }

  func testShouldAssignHeightFromCenterYAndTop() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    v1.centerY = v2.centerY
    v1.top = v2.top
    XCTAssertEqual(v1.frame.size.height, v2.frame.size.height)
  }

  func testShouldAssignWidthFromLeftAndRight() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    v1.left = v2.left
    v1.right = v2.right
    XCTAssertEqual(v1.frame.size.width, v2.frame.size.width)
  }

  func testShouldAssignWidthFromRightAndLeft() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    v1.right = v2.right
    v1.left = v2.left
    XCTAssertEqual(v1.frame.size.width, v2.frame.size.width)
  }

  func testShouldAssignWidthFromLeftAndCenterX() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    v1.left = v2.left
    v1.centerX = v2.centerX
    XCTAssertEqual(v1.frame.size.width, v2.frame.size.width)
  }

  func testShouldAssignWidthFromCenterXAndLeft() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    v1.centerX = v2.centerX
    v1.left = v2.left
    XCTAssertEqual(v1.frame.size.width, v2.frame.size.width)
  }

  func testShouldAssignWidthFromCenterXAndRight() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    v1.centerX = v2.centerX
    v1.right = v2.right
    XCTAssertEqual(v1.frame.size.width, v2.frame.size.width)
  }

  func testShouldAssignWidthFromRightAndCenterX() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    v1.right = v2.right
    v1.centerX = v2.centerX
    XCTAssertEqual(v1.frame.size.width, v2.frame.size.width)
  }

  func testShouldAssignWidth() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    // fixed
    v1.width = .fixed(300)
    XCTAssertEqual(v1.frame.size.width, 300)

    // scalable
    v1.width = .scalable(300)
    XCTAssertEqual(v1.frame.size.width, 300 * multiplier)

    // from another view
    v1.width = v2.width
    XCTAssertEqual(v1.frame.size.width, v2Frame.size.width)
  }

  func testShouldAlignTop() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    // no margin
    v1.top = v2.top
    XCTAssertEqual(v1.frame.origin.y, v2Frame.origin.y)

    // margin fixed
    v1.top = v2.top + .fixed(50)
    XCTAssertEqual(v1.frame.origin.y, v2Frame.origin.y + 50)

    // margin scalable
    v1.top = v2.top + .scalable(50)
    XCTAssertEqual(v1.frame.origin.y, v2Frame.origin.y + 50 * multiplier)

    // negative margin
    v1.top = v2.top + .scalable(-50)
    XCTAssertEqual(v1.frame.origin.y, v2Frame.origin.y - 50 * multiplier)
  }

  func testShouldAlignLeft() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    // no margin
    v1.left = v2.left
    XCTAssertEqual(v1.frame.origin.x, v2Frame.origin.x)

    // margin fixed
    v1.left = v2.left + .fixed(50)
    XCTAssertEqual(v1.frame.origin.x, v2Frame.origin.x + 50)

    // margin scalable
    v1.left = v2.left + .scalable(50)
    XCTAssertEqual(v1.frame.origin.x, v2Frame.origin.x + 50 * multiplier)

    // negative margin
    v1.left = v2.left + .scalable(-50)
    XCTAssertEqual(v1.frame.origin.x, v2Frame.origin.x - 50 * multiplier)
  }

  func testShouldAlignBottom() {
  /*
                        x

   +--------------------->
   |
   |   +--------------+
   |   |              |
   |   |              |
   |   |              |  +----------+
   |   |              |  |          |
   |   |              |  |          |
   |   |    v2        |  |          |
   |   |              |  |   v1     |
   |   |              |  |          |
y  v   |              |  |          |
       |              |  |          |
       +--------------+  +----------+
 
     
    In order to bottom align v2 to v1 we should calculate the y coordinate of the lower corner of v1 (origin + height)
    and substract the height of v2. In this way we can calculate the y coordinate of the origin of v1
     
    In addition to that we can add/remove space using margins
 */

    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)
    v1.height = .fixed(400)
    v1.width = .fixed(400)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    // no margin
    v1.bottom = v2.bottom
    XCTAssertEqual(v1.frame.origin.y, v2.frame.origin.y + v2.frame.size.height - v1.frame.size.height)

    // margin fixed
    v1.bottom = v2.bottom + .fixed(50)
    XCTAssertEqual(v1.frame.origin.y, v2.frame.origin.y + v2.frame.size.height - v1.frame.size.height + 50)

    // margin scalable
    v1.bottom = v2.bottom + .scalable(50)
    XCTAssertEqual(v1.frame.origin.y, v2.frame.origin.y + v2.frame.size.height - v1.frame.size.height + 50 * multiplier)

    // negative margin
    v1.bottom = v2.bottom + .scalable(-50)
    XCTAssertEqual(v1.frame.origin.y, v2.frame.origin.y + v2.frame.size.height - v1.frame.size.height - 50 * multiplier)

  }

  func testShouldAlignRight() {
    /*
                        x
     
   +--------------------->
   |
   |  +-------------------+
   |  |        v2         |
   |  |                   |
   |  +-------------------+
   |
   |          +-----------+
   |          |    v1     |
   |          +-----------+
   |
y  v
     
     
     In order to right align v2 to v1 we should calculate the x coordinate of the right corner of v1 (origin + width)
     and substract the width of v2. In this way we can calculate the x coordinate of the origin of v1
     
     In addition to that we can add/remove space using margins
    */

    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)
    v1.height = .fixed(400)
    v1.width = .fixed(400)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    // no margin
    v1.right = v2.right
    XCTAssertEqual(v1.frame.origin.x, v2.frame.origin.x + v2.frame.size.width - v1.frame.size.width)

    // margin fixed
    v1.right = v2.right + .fixed(50)
    XCTAssertEqual(v1.frame.origin.x, v2.frame.origin.x + v2.frame.size.width - v1.frame.size.width + 50)

    // margin scalable
    v1.right = v2.right + .scalable(50)
    XCTAssertEqual(v1.frame.origin.x, v2.frame.origin.x + v2.frame.size.width - v1.frame.size.width + 50 * multiplier)

    // negative
    v1.right = v2.right + .scalable(-50)
    XCTAssertEqual(v1.frame.origin.x, v2.frame.origin.x + v2.frame.size.width - v1.frame.size.width - 50 * multiplier)
  }

  func testShouldAlignCenterX() {
/*
 
                             x
  +-------------------------->
  |
  |    +--------------+
  |    |      v2      |
  |    |              |
  |    +--------------+
  |          +---+
  |          |   |
  |          |   |
  |          |   |
  |          | v1|
  |          |   |
  |          |   |
  |          +---+
y v

  
  In order to center X align v2 to v1 we should calculate the x coordinate of the middle point of v1 which is origin.x + width / 2
  We then subtract half of the width of v2 and this way we have found the x coordinate of the origin of v1
 
  In addition to this we can add/remove margins
*/

    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)
    v1.height = .fixed(400)
    v1.width = .fixed(400)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    // no margin
    v1.centerX = v2.centerX
    XCTAssertEqual(v1.frame.origin.x, v2.frame.origin.x + v2.frame.size.width / 2.0 - v1.frame.size.width / 2.0)

    // margin fixed
    v1.centerX = v2.centerX + .fixed(50)
    XCTAssertEqual(v1.frame.origin.x, v2.frame.origin.x + v2.frame.size.width / 2.0 - v1.frame.size.width / 2.0 + 50)

    // margin scalable
    v1.centerX = v2.centerX + .scalable(50)
    XCTAssertEqual(v1.frame.origin.x, v2.frame.origin.x + v2.frame.size.width / 2.0 - v1.frame.size.width / 2.0 + 50 * multiplier)

    // negative margin
    v1.centerX = v2.centerX + .scalable(-50)
    XCTAssertEqual(v1.frame.origin.x, v2.frame.origin.x + v2.frame.size.width / 2.0 - v1.frame.size.width / 2.0 - 50 * multiplier)
  }

  func testShouldAlignCenterY() {
    /*
     
     x
     +--------------------------->
     |
     |    +-----+
     |    |     |
     |    |     |    +----+
     |    |     |    |    |
     |    |     |    |    |
     |    |     |    |    |
     |    |  v2 |    | v1 |
     |    |     |    |    |
     |    |     |    +----+
     |    |     |
     |    |     |
     |    +-----+
   y v
     
     In order to center Y align v2 to v1 we should calculate the y coordinate 
     of the middle point of v1 which is origin.y + height / 2
     We then subtract half of the height of v2 and this way we have found the y coordinate of the origin of v1
     
     In addition to this we can add/remove margins
     */

    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)
    v1.height = .fixed(400)
    v1.width = .fixed(400)

    let v2Frame = CGRect(x: 20, y: 50, width: 400, height: 400)
    let v2 = PlasticView(hierarchyManager: hM, key: "B", multiplier: multiplier, frame: v2Frame)

    // no margin
    v1.centerY = v2.centerY
    XCTAssertEqual(v1.frame.origin.y, v2.frame.origin.y + v2.frame.size.height / 2.0 - v1.frame.size.height / 2.0)

    // margin fixed
    v1.centerY = v2.centerY + .fixed(50)
    XCTAssertEqual(v1.frame.origin.y, v2.frame.origin.y + v2.frame.size.height / 2.0 - v1.frame.size.height / 2.0 + 50)

    // margin scalable
    v1.centerY = v2.centerY + .scalable(50)
    XCTAssertEqual(v1.frame.origin.y,
                   v2.frame.origin.y + v2.frame.size.height / 2.0 - v1.frame.size.height / 2.0 + 50 * multiplier)

    // margin scalable with CGFloat
    v1.centerY = v2.centerY + 150
    XCTAssertEqual(v1.frame.origin.y,
                   v2.frame.origin.y + v2.frame.size.height / 2.0 - v1.frame.size.height / 2.0 + 150 * multiplier)

    // negative margin scalable with CGFloat
    v1.centerY = v2.centerY - 150
    XCTAssertEqual(v1.frame.origin.y,
                   v2.frame.origin.y + v2.frame.size.height / 2.0 - v1.frame.size.height / 2.0 - 150 * multiplier)

    // negative margin
    v1.centerY = v2.centerY + .scalable(-50)
    XCTAssertEqual(v1.frame.origin.y,
                   v2.frame.origin.y + v2.frame.size.height / 2.0 - v1.frame.size.height / 2.0 - 50 * multiplier)
  }

  func testShouldSetSize() {
    let hM = DummyHierarchyManager()
    let multiplier: CGFloat = 0.66

    let v1 = PlasticView(hierarchyManager: hM, key: "A", multiplier: multiplier, frame: .zero)

    // non scalable
    v1.size = .fixed(300, 300)
    XCTAssertEqual(v1.frame.size, CGSize(width: 300, height: 300))

    v1.size = .scalable(300, 300)
    XCTAssertEqual(v1.frame.size, CGSize(width: 300 * multiplier, height: 300 * multiplier))
  }

}
