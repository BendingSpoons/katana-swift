import XCTest
import Katana

class NodeDescriptionTest: XCTestCase {
  private func view(withBackground color: TestColor, key: String?) -> View {
    var props = ViewProps()
    props.backgroundColor = color
    props.key = key
    return View(props: props)
  }
  
  private func image(withBackground color: TestColor, key: String?) -> Image {
    var props = ImageProps()
    props.backgroundColor = color
    props.key = key
    return Image(props: props)
  }
  
  func testreplaceKey() {
    let view1 = view(withBackground: .blue, key: nil)
    let view2 = view(withBackground: .blue, key: nil)
    let img = image(withBackground: .blue, key: nil)

    XCTAssert(view1.replaceKey == view1.replaceKey)
    XCTAssert(view1.replaceKey == view2.replaceKey)
    XCTAssert(img.replaceKey == img.replaceKey)
    XCTAssert(img.replaceKey != view1.replaceKey)
  }
  
  func testReplaceKeyWihtKeyableProps() {
    let view1 = view(withBackground: .blue, key: "a")
    let view2 = view(withBackground: .blue, key: "a")
    let view3 = view(withBackground: .blue, key: "b")
    let image1 = image(withBackground: .blue, key: "a")
    let image2 = image(withBackground: .blue, key: "d")

    
    XCTAssert(view1.replaceKey == view1.replaceKey)
    XCTAssert(view1.replaceKey == view2.replaceKey)
    XCTAssert(view1.replaceKey != view3.replaceKey)
    XCTAssert(view1.replaceKey != image1.replaceKey)
    XCTAssert(view1.replaceKey != image2.replaceKey)
  }
}
