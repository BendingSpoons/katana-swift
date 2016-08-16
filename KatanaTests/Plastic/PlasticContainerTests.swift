//
//  PlasticContainerTests.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import XCTest
@testable import Katana

class PlasticViewsContainerTests: XCTestCase {
  
  func testShouldCreateRootElement() {
    let hierarchy: [AnyNodeDescription] = []
    let rootFrame = CGRect(x: 0, y: 10, width: 20, height: 30)
    let plasticViewsContainer = PlasticViewsContainer(rootFrame: rootFrame, children: hierarchy)
    
    let rootPlaceholder = plasticViewsContainer.rootView
    XCTAssertEqual(rootPlaceholder.frame, rootFrame)
  }
  
  
  func testShouldCreateChildren() {
    
    let hierarchy: [AnyNodeDescription] = [
      View(props: ViewProps().key("One"), children: [
        View(props: ViewProps().key("One-A")),
        View(props: ViewProps().key("One-B")),
        ]),
      
      View(props: ViewProps().key("Two")),
      View(props: ViewProps()),
      View(props: ViewProps().key("Four")),
      ]
    
    
    let plasticViewsContainer = PlasticViewsContainer(rootFrame: CGRect.zero, children: hierarchy)
    
    XCTAssertNotNil(plasticViewsContainer.rootView)
    XCTAssertNotNil(plasticViewsContainer["One"])
    XCTAssertNotNil(plasticViewsContainer["One-A"])
    XCTAssertNotNil(plasticViewsContainer["One-B"])
    XCTAssertNotNil(plasticViewsContainer["Two"])
    XCTAssertNotNil(plasticViewsContainer["Four"])
  }
}
