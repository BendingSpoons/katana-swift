import XCTest
@testable import Katana


class NodeTest: XCTestCase {
  func testNodeDeallocation() {


    let store = Store<SmartReducer<MyAppState>>(middlewares: [])
    let node = App(props: AppProps(i:0), children: []).rootNode(store: store).node
    
    var references = collectNodes(node: node).map { WeakNode(value: $0) }
    XCTAssert(references.count == 6)
    XCTAssert(references.filter { $0.value != nil }.count == 6)
    
    try! node.update(description: App(props: AppProps(i:1), children: []))
    XCTAssert(references.count == 6)
    XCTAssertEqual(references.filter { $0.value != nil }.count, 5)
  
    references = collectNodes(node: node).map { WeakNode(value: $0) }
    XCTAssert(references.count == 5)
    XCTAssertEqual(references.filter { $0.value != nil }.count, 5)
    
    try! node.update(description: App(props: AppProps(i:2), children: []))
    XCTAssert(references.count == 5)
    XCTAssertEqual(references.filter { $0.value != nil }.count, 0)
    
    references = collectNodes(node: node).map { WeakNode(value: $0) }
    XCTAssert(references.count == 0)
    XCTAssertEqual(references.filter { $0.value != nil }.count, 0)
    
    
  }
  
  func testViewDeallocation() {
    
    let store = Store<SmartReducer<AppState>>(middlewares: [])
    let node = App(props: AppProps(i:0), children: []).rootNode(store: store).node
    
    let rootVew = UIView()
    node.draw(container: rootVew)
    
    var references = collectView(view: rootVew)
      .filter { $0.tag ==  Katana.VIEW_TAG }
      .map { WeakView(value: $0) }
    
    autoreleasepool {
      try! node.update(description: App(props: AppProps(i:2), children: []))
    }

    XCTAssertEqual(references.filter { $0.value != nil }.count, 1)

    references = collectView(view: rootVew)
      .filter { $0.tag ==  Katana.VIEW_TAG }
      .map { WeakView(value: $0) }
    
    
    XCTAssertEqual(references.count, 1)
  }

}

fileprivate struct MyAppState : State {}

fileprivate struct AppProps : NodeProps {
  var frame: CGRect = CGRect.zero
  var i: Int
  
  static func ==(lhs: AppProps, rhs: AppProps) -> Bool {
    return lhs.frame == rhs.frame && lhs.i == rhs.i
  }
  
  init(i:Int) {
    self.i = i
  }
}

fileprivate struct App : NodeDescription {
  
  var props : AppProps
  var children: [AnyNodeDescription] = []
  
  
  static func render(props: AppProps,
                     state: EmptyState,
                     update: @escaping  (EmptyState) -> (),
                     dispatch: StoreDispatch) -> [AnyNodeDescription] {
    
    
    
    let i = props.i
    
    if (i == 0) {
      
      return [
        View(props: ViewProps().frame(0,0,150,150).color(.gray)) {
          [
            Button(props: ButtonProps().frame(50,50,100,100)
              .color(.orange, state: .normal)
              .color(.orange, state: .highlighted)
              .text("state \(i)", fontSize: 10)
              .onTap({ update(EmptyState()) })
            ),
            
            View(props: ViewProps().frame(0,0,150,150).color(.gray))
          ]
        }
      ]
      
    } else if (i == 1) {
      return [
        View(props: ViewProps().frame(0,0,150,150).color(.gray)) {
          [
            Button(props: ButtonProps().frame(50,50,100,100)
              .color(.orange, state: .normal)
              .color(.orange, state: .highlighted)
              .text("state \(i)", fontSize: 10)
              .onTap({ update(EmptyState()) })
            )
          ]
        }
      ]
      
    } else {
      return []
    }
    
  }
}


fileprivate class WeakNode {
  weak var value : AnyNode?
  init(value: AnyNode) {
    self.value = value
  }
}

fileprivate class WeakView {
  weak var value : UIView?
  init(value: UIView) {
    self.value = value
  }
}

fileprivate func collectNodes(node: AnyNode) -> [AnyNode] {
  return (node.children!.map { collectNodes(node: $0) }.reduce([], { $0 + $1 })) + node.children!
}

fileprivate func collectView(view: UIView) -> [UIView] {
  return (view.subviews.map { collectView(view: $0) }.reduce([], { $0 + $1 })) + view.subviews
}




