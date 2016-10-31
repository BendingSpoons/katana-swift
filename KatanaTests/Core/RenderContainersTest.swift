import XCTest
import Katana

class DrawableContainersTest: XCTestCase {
  
  func testAddAndRemoveAll() {
    
    let r = UIView()
    
    let child = r.addChild { UIView() }
    XCTAssert(r.children().count == 1)
    XCTAssert(child.children().count == 0)
    
    r.removeAll()
    XCTAssert(r.children().count == 0)
  }
  
  func testRemove() {
    
    let r = UIView()
    _ = r.addChild { UIView() }
    _ = r.addChild { UIView() }
    _ = r.addChild { UIView() }
    r.removeChild(r.children()[0])
    let children = r.children()
    XCTAssert(children.count == 2)
  }
}
