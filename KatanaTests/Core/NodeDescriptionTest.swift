import XCTest
import Katana
import KatanaElements

class NodeDescriptionTest: XCTestCase {
  
  func testreplaceKey() {
    
    let view1 = View(props: ViewProps().color(.blue))
    let view2 = View(props: ViewProps().color(.blue))
    let button = Button(props: ButtonProps().color(.blue))

    XCTAssert(view1.replaceKey == view1.replaceKey)
    XCTAssert(view1.replaceKey == view2.replaceKey)
    XCTAssert(button.replaceKey == button.replaceKey)
    XCTAssert(button.replaceKey != view1.replaceKey)

  }
  
  func testReplaceKeyWihtKeyableProps() {
    
    let view1 = View(props: ViewProps().color(.blue).key("a"))
    let view2 = View(props: ViewProps().color(.blue).key("a"))
    let view3 = View(props: ViewProps().color(.blue).key("b"))
    let button1 = Button(props: ButtonProps().color(.blue).key("a"))
    let button2 = Button(props: ButtonProps().color(.blue).key("d"))

    
    XCTAssert(view1.replaceKey == view1.replaceKey)
    XCTAssert(view1.replaceKey == view2.replaceKey)
    XCTAssert(view1.replaceKey != view3.replaceKey)
    XCTAssert(view1.replaceKey != button1.replaceKey)
    XCTAssert(view1.replaceKey != button2.replaceKey)

  }

}
