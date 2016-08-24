import XCTest
import Katana

class DrawableContainersTest: XCTestCase {
  
  func testAddAndRemoveAll() {
    
    let r = UIView()
    
    let child = r.add { UIView() }
    XCTAssert(r.children().count == 1)
    XCTAssert(child.children().count == 0)
    
    r.removeAll()
    XCTAssert(r.children().count == 0)
  }
  
  func testRemove() {
    
    let r = UIView()
    _ = r.add { UIView() }
    _ = r.add { UIView() }
    _ = r.add { UIView() }
    r.remove(child: r.children()[0])
    let children = r.children()
    XCTAssert(children.count == 2)
  }
}
