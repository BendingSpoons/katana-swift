import XCTest
import Katana

class KatanaTests: XCTestCase {
  
  func testAddAndRemoveAll() {
    
    
    let r1 = RenderProfiler() { _ = $0}
    let r2 = RenderProfiler() { _ = $0}
    let r = RenderContainers(containers: [r1,r2])
    let child = r.add { UIView() }
    XCTAssert(r.children().count == 1)
    XCTAssert(r1.children().count == 1)
    XCTAssert(r2.children().count == 1)
    XCTAssert(child.children().count == 0)
    r.removeAll()
    XCTAssert(r.children().count == 0)
    XCTAssert(r1.children().count == 0)
    XCTAssert(r2.children().count == 0)
    
  }
  
  func testRemove() {
    
    
    let r1 = RenderProfiler { _ = $0}
    let r2 = RenderProfiler { _ = $0}
    let r = RenderContainers(containers: [r1,r2])
    _ = r.add { UIView() }
    _ = r.add { UIView() }
    _ = r.add { UIView() }
    r.remove(child: r.children()[0])
    let children = r.children()
    XCTAssert(children.count == 2)
    XCTAssert(r1.children().count == 2)
    XCTAssert(r2.children().count == 2)
    
  }
  
}
