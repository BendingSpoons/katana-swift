import XCTest
@testable import Katana

class Collections: XCTestCase {

  func testIsSorted() {

    XCTAssertTrue([1, 2, 3].isSorted)
    XCTAssertTrue([1, 3, 5, 10].isSorted)
    XCTAssertTrue([1, 1, 2, 3, 10].isSorted)
    XCTAssertTrue([1, 1, 1].isSorted)
    XCTAssertFalse([10, 1, 2, 3].isSorted)
    XCTAssertFalse([10, 10, 1, 2, 3].isSorted)

  }

}
