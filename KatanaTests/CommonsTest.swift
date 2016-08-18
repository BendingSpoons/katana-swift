import XCTest
import Katana

class CommonsTest: XCTestCase {
  
  func testFramable() {
    
    struct Picture : Frameable {
      private var frame =  CGRect.zero
    }
    
    let p = Picture()
    XCTAssert(p.frame == CGRect.zero)
    let p1 = p.frame(10,10,10,10)
    XCTAssert(p1.frame == CGRect(x: 10, y: 10, width: 10, height: 10))
    XCTAssert(p.frame == CGRect.zero)
    let p2 = p.frame(p1.frame.size)
    XCTAssert(p2.frame == CGRect(x: 0, y: 0, width: 10, height: 10))
    XCTAssert(p1.frame == CGRect(x: 10, y: 10, width: 10, height: 10))
    XCTAssert(p.frame == CGRect.zero)

  }
}
