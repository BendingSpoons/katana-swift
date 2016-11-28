import XCTest
@testable import Katana

class NodeTest: XCTestCase {
  func testNodeDeallocation() {
    let renderer = Renderer(rootDescription: App(props: AppProps(i:0)), store: nil)
    let node = renderer.rootNode!
    
    var references = collectNodes(node: node).map { WeakNode(value: $0) }
    XCTAssert(references.count == 3)
    XCTAssert(references.filter { $0.value != nil }.count == 3)
    
    node.update(with: App(props: AppProps(i:1)))
    XCTAssert(references.count == 3)
    XCTAssertEqual(references.filter { $0.value != nil }.count, 2)
  
    references = collectNodes(node: node).map { WeakNode(value: $0) }
    XCTAssert(references.count == 2)
    XCTAssertEqual(references.filter { $0.value != nil }.count, 2)
    
    node.update(with: App(props: AppProps(i:2)))
    XCTAssert(references.count == 2)
    XCTAssertEqual(references.filter { $0.value != nil }.count, 0)
    
    references = collectNodes(node: node).map { WeakNode(value: $0) }
    XCTAssert(references.count == 0)
    XCTAssertEqual(references.filter { $0.value != nil }.count, 0)
  }
  
  func testViewDeallocation() {
    let renderer = Renderer(rootDescription: App(props: AppProps(i:0)), store: nil)
    let node = renderer.rootNode!
    
    let rootVew = TestView()
    renderer.render(in: rootVew)
    
    var references = collectView(view: rootVew)
      .filter { $0.tagValue ==  Katana.VIEWTAG }
      .map { WeakView(value: $0) }
    
    autoreleasepool {
      node.update(with: App(props: AppProps(i:2)))
    }

    XCTAssertEqual(references.filter { $0.value != nil }.count, 1)

    references = collectView(view: rootVew)
      .filter { $0.tagValue ==  Katana.VIEWTAG }
      .map { WeakView(value: $0) }
    
    
    XCTAssertEqual(references.count, 1)
  }

}

fileprivate struct MyAppState: State {}

fileprivate struct AppProps: NodeDescriptionProps {
  var frame: CGRect = CGRect.zero
  var key: String?
  var alpha: CGFloat = 1.0
  
  var i: Int
  
  static func == (lhs: AppProps, rhs: AppProps) -> Bool {
    return lhs.frame == rhs.frame && lhs.i == rhs.i
  }
  
  init(i: Int) {
    self.i = i
  }
}

fileprivate struct App: NodeDescription {
  typealias NativeView = TestView

  var props: AppProps
  var children: [AnyNodeDescription] = []
  
  init(props: AppProps) {
    self.props = props
  }
  
  public static func childrenDescriptions(props: AppProps,
                            state: EmptyState,
                            update: @escaping (EmptyState) -> (),
                            dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {

    let i = props.i
    
    if i == 0 {
      var imageProps = ImageProps()
      imageProps.backgroundColor = .blue
      let image = Image(props: imageProps)

      var innerViewProps = ViewProps()
      innerViewProps.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
      innerViewProps.backgroundColor = .gray
      let innerView = View(props: innerViewProps)
      
      var viewProps = ViewProps()
      viewProps.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
      viewProps.backgroundColor = .gray
      viewProps.children = [image, innerView]
      let view = View(props: viewProps)
      
      return [view]
      
    } else if i == 1 {
      
      var imageProps = ImageProps()
      imageProps.backgroundColor = .blue
      let image = Image(props: imageProps)
      
      var viewProps = ViewProps()
      viewProps.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
      viewProps.backgroundColor = .gray
      viewProps.children = [image]
      let view = View(props: viewProps)
      
      return [view]
      
    } else {
      return []
    }
    
  }
}


fileprivate class WeakNode {
  weak var value: AnyNode?
  init(value: AnyNode) {
    self.value = value
  }
}

fileprivate class WeakView {
  weak var value: BaseView?
  init(value: BaseView) {
    self.value = value
  }
}

fileprivate func collectNodes(node: AnyNode) -> [AnyNode] {
  return (node.children.map { collectNodes(node: $0) }.reduce([], { $0 + $1 })) + node.children
}

fileprivate func collectView(view: BaseView) -> [BaseView] {
  return (view.subviews.map { collectView(view: $0) }.reduce([], { $0 + $1 })) + view.subviews
}
