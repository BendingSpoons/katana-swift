import XCTest
import Katana

class NodeDescriptionTest: XCTestCase {
  
  func testReplaceKey() {
    
    let view1 = View(props: ViewProps().color(.blue))
    let view2 = View(props: ViewProps().color(.blue))
    let button = Button(props: ButtonProps().color(.blue))

    XCTAssert(view1.replaceKey() == view1.replaceKey())
    XCTAssert(view1.replaceKey() == view2.replaceKey())
    XCTAssert(button.replaceKey() == button.replaceKey())
    XCTAssert(button.replaceKey() != view1.replaceKey())

  }

}
