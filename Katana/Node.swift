//
//  KatanaNode.swift
//  Katana
//
//  Created by Luca Querella on 02/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit


public protocol Node {
    var description : NodeDescription { get }
    
    func render(on container: RenderContainer)
    func update(description: NodeDescription) throws
}

public final class LogicNode<L:Logic> : Node {
    
    private var props: L.Props
    private var state: L.State
    public var description: NodeDescription
    private var child: Node?
    private var container: RenderContainer?
    
    init(description: LogicNodeDescription<L>) {
        self.description = description
        self.props = description.props
        self.state = L.initialState
        self.child = L.logic(state: self.state,
                             props: self.props,
                             update: self.update).node()
        
    }
    
    func update(state: L.State) {
        self.update(props: self.props, state: state)
    }
    
    public func update(description: NodeDescription) throws {
        let description = description as! LogicNodeDescription<L>
        self.description = description
        self.update(props: description.props, state: state)
    }
    
    public func update(props: L.Props, state: L.State) {
        
        guard let child = self.child else {
            fatalError("update should not be called at this time")
        }
        
        if ((state == self.state) && (props == self.props)) {
            return
        }
        
        self.state = state
        self.props = props
        
        let description = L.logic(state: self.state,
                                  props: self.props,
                                  update: self.update)
        
        if (description.replaceKey() == child.description.replaceKey()) {
            try! child.update(description: description)
            
        } else {
            
            let child = description.node()
            
            if let container = self.container {
                container.removeAll()
                child.render(on: container)
            }
            
            self.child = child
        }
        
    }
    
    public func render(on container: RenderContainer) {
        
        if (self.container != nil)  {
            fatalError("node can be render on a single View")
        }
        
        guard let child = self.child else {
            fatalError("render should not be called at this time")
        }
        
        self.container = container
        child.render(on: container)
        
    }
    
}


public final class VisualNode<V:Visual> : Node {
    
    private var props: V.Props
    private var children: [Node]
    public var description: NodeDescription
    private var container: RenderContainer?
    
    init(description: VisualNodeDescription<V>) {
        self.description = description
        self.props = description.props
        self.children = description.children.map { $0.node() }
    }
    
    public func update(description: NodeDescription) throws {
        let description = description as! VisualNodeDescription<V>
        self.description = description
        self.update(props: description.props, children: description.children)
    }
    
    public func update(props: V.Props, children: [NodeDescription]) {
        

        //assume the view has already been rendered
        var applyProps = false
        
        //if the props are changed update the uiview
        if (self.props != props) {
            self.props = props
            applyProps = true
        }
        
        //map current nodes
        var currentChildren : [Int:[(node: Node, index: Int)]] = [:]
        
        for (index,child) in self.children.enumerated() {
            
            let key = child.description.replaceKey()
            let value = (node: child, index: index)
            
            if currentChildren[key] == nil {
                currentChildren[key] = [value]
            } else {
                currentChildren[key]?.append(value)
            }
        }
        
        var nodes : [Node] = []
        var viewIndex : [Int] = []
        var nodesToRender : [Node] = []
        
        //for each new descriptions
        for description in children {
            
            //if you find a replacement
            if currentChildren[description.replaceKey()]?.count > 0 {
                
                let replacement = currentChildren[description.replaceKey()]!.removeFirst()
                
                //if so upate it
                assert(replacement.node.description.replaceKey() == description.replaceKey())
                try! replacement.node.update(description: description)
                
                nodes.append(replacement.node)
                viewIndex.append(replacement.index)
                
            } else {
                
                //else create a new node
                let node = description.node()
                viewIndex.append(self.children.count + nodesToRender.count)
                nodes.append(node)
                nodesToRender.append(node)
            }
            
        }
        
        self.children = nodes
        self.updateRender(applyProps: applyProps,
                          childrenToRender: nodesToRender,
                          viewIndexes: viewIndex)
    }
    
    public func render(on container: RenderContainer) {
        
        if (self.container != nil)  {
            fatalError("node can be render on a single View")
        }
        
        self.container = container.add { V.View() }
        self.container?.update { view in
            V.applyProps(props: self.props, view: view as! V.View)
        }
        
        self.children.forEach { child in
            child.render(on: self.container!)
        }
    }
    
    public func updateRender(applyProps: Bool, childrenToRender: [Node], viewIndexes: [Int]) {
        
        guard let container = self.container else {
            return
        }

        assert(viewIndexes.count == self.children.count)
        
        if (applyProps)  {
            container.update { view in
                V.applyProps(props: self.props, view: view as! V.View)
            }
        }
        
        childrenToRender.forEach { node in
            return node.render(on: container)
        }
        
        
        var currentSubviews : [RenderContainerChild?] =  container.children().map { $0 }
        
        for viewIndex in viewIndexes {
            let currentSubview = currentSubviews[viewIndex]!
            container.bringToFront(child: currentSubview)
            currentSubviews[viewIndex] = nil
        }
        
        for view in currentSubviews {
            if let viewToRemove = view {
                self.container?.remove(child: viewToRemove)
            }
        }
    }
    
}

