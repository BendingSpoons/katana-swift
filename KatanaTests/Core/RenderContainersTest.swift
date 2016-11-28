import XCTest
import Katana


class UIViewsTest: XCTestCase {
  
  func testAddAndRemoveAll() {
    
    let r = TestView()
    
    let child = r.addChild { TestView() }
    XCTAssert(r.children().count == 1)
    XCTAssert(child.children().count == 0)
    
    r.removeAllChildren()
    XCTAssert(r.children().count == 0)
  }
  
  func testRemove() {
    
    let r = TestView()
    _ = r.addChild { TestView() }
    _ = r.addChild { TestView() }
    _ = r.addChild { TestView() }
    r.removeChild(r.children()[0])
    let children = r.children()
    XCTAssert(children.count == 2)
  }
}
