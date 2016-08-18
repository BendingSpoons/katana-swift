import XCTest
@testable import Katana

struct AppProps : Equatable,Frameable {
  var frame: CGRect = CGRect.zero
  var i: Int
  
  static func ==(lhs: AppProps, rhs: AppProps) -> Bool {
    return lhs.frame == rhs.frame && lhs.i == rhs.i
  }
  
  init(i:Int) {
    self.i = i
  }
}

struct App : NodeDescription {
  var props : AppProps
  var children: [AnyNodeDescription] = []
  
  static var initialState = EmptyState()
  static var viewType = UIView.self
  
  
  
  static func render(props: AppProps,
                     state: EmptyState,
                     update: (EmptyState)->()) -> [AnyNodeDescription] {
    
    let i = props.i
    
    if (i == 0) {
      
      return [
        View(props: ViewProps().frame(0,0,150,150).color(.gray)) {
          [
            Button(props: ButtonProps().frame(50,50,100,100)
              .color(.orange, state: .normal)
              .color(.orange, state: .highlighted)
              .text("state \(i)", fontSize: 10)
              .onTap({ update(EmptyState()) })),
            
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
              .onTap({ update(EmptyState()) }))
          ]
        }
      ]
    
    } else {
      return []
    }
    
  }
}


class WeakNode {
  weak var value : AnyNode?
  init(value: AnyNode) {
    self.value = value
  }
}

class WeakView {
  weak var value : UIView?
  init(value: UIView) {
    self.value = value
  }
}

func collectNodes(node: AnyNode) -> [AnyNode] {
  return (node.children!.map { collectNodes(node: $0) }.reduce([], { $0 + $1 })) + node.children!
}

func collectView(view: UIView) -> [UIView] {
  return (view.subviews.map { collectView(view: $0) }.reduce([], { $0 + $1 })) + view.subviews
}

class NodeTest: XCTestCase {
  
  
  func testNodeDeallocation() {
    let root = App(props: AppProps(i:0), children: []).node()
    var references = collectNodes(node: root).map { WeakNode(value: $0) }
    XCTAssert(references.count == 6)
    XCTAssert(references.filter { $0.value != nil }.count == 6)
    
    try! root.update(description: App(props: AppProps(i:1), children: []))
    XCTAssert(references.count == 6)
    XCTAssertEqual(references.filter { $0.value != nil }.count, 5)
  
    references = collectNodes(node: root).map { WeakNode(value: $0) }
    XCTAssert(references.count == 5)
    XCTAssertEqual(references.filter { $0.value != nil }.count, 5)
    
    try! root.update(description: App(props: AppProps(i:2), children: []))
    XCTAssert(references.count == 5)
    XCTAssertEqual(references.filter { $0.value != nil }.count, 0)
    
    references = collectNodes(node: root).map { WeakNode(value: $0) }
    XCTAssert(references.count == 0)
    XCTAssertEqual(references.filter { $0.value != nil }.count, 0)
    
    
  }
  
  
  func testViewDeallocation() {
    let root = App(props: AppProps(i:0), children: []).node()
    
    let rootVew = UIView()
    root.render(container: rootVew)
    
    var references = collectView(view: rootVew)
      .filter { $0.tag ==  Katana.VIEW_TAG }
      .map { WeakView(value: $0) }
    
    autoreleasepool {
      try! root.update(description: App(props: AppProps(i:2), children: []))
    }

    
    XCTAssertEqual(references.filter { $0.value != nil }.count, 1)

    references = collectView(view: rootVew)
      .filter { $0.tag ==  Katana.VIEW_TAG }
      .map { WeakView(value: $0) }
    
    
    XCTAssertEqual(references.count, 1)
  }
  
}