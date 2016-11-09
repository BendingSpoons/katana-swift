//
//  CodingLove.swift
//  Katana
//
//  Created by Alain Caltieri on 07/11/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import Katana
import KatanaElements


extension CodingLove {
    enum Keys {
        case tableView
        case titleLabel
    }
    
    struct Props: NodeDescriptionProps, Buildable {
        var frame: CGRect = .zero
        var posts: [Post] = [Post]()
        var loading: Bool = true
        var allPostsFetched: Bool = false
    }
    
    struct TableViewDelegate: TableDelegate {
        var posts: [Post]
        
        public func numberOfSections() -> Int {
            return 2
        }
        
        public func numberOfRows(forSection section: Int) -> Int {
            if section == 0 {
                return posts.count
            }
            return 1
        }
        
        public func cellDescription(forRowAt indexPath: IndexPath) -> AnyNodeDescription {
            if indexPath.section == 0 {
                return PostCell(props: PostCell.Props.build({
                    $0.index = indexPath.row
                }))
            }

            return FetchMoreCell(props: FetchMoreCell.Props())
        }
        
        public func height(forRowAt indexPath: IndexPath) -> Katana.Value {
            if indexPath.section == 0 {
                return .scalable(500)
            }
            return .scalable(100)
        }
        
        public func isEqual(to anotherDelegate: TableDelegate) -> Bool {
            if !(anotherDelegate is TableViewDelegate) {
                return false
            }
            
            guard let anotherDelegate = anotherDelegate as? TableViewDelegate else {
                return false
            }
            
            if posts != anotherDelegate.posts {
                return false
            }
            
            return true
        }
    }
    
}


struct CodingLove: ConnectedNodeDescription, PlasticNodeDescription, PlasticNodeDescriptionWithReferenceSize {
    typealias StateType = EmptyState
    typealias PropsType = Props
    
    var props: PropsType
    
    static var referenceSize = CGSize(width: 640, height: 960)
    
    static func childrenDescriptions(props: PropsType,
                                     state: StateType,
                                     update: @escaping (StateType)->(),
                                     dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
        return [
            Label(props: LabelProps.build({
                $0.setKey(Keys.titleLabel)
                $0.text = NSAttributedString(string: "The Coding Love", attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 25)
                ])
                $0.textAlignment = NSTextAlignment.center
            })),
            Table(props: TableProps.build({
                $0.setKey(Keys.tableView)
                $0.delegate = TableViewDelegate(posts: props.posts)
            }))
        ]
    }
    
    static func layout(views: ViewsContainer<Keys>, props: PropsType, state: EmptyState) {
        let rootView = views.nativeView
        let title = views[Keys.titleLabel]!
        let table = views[Keys.tableView]!
        
        title.asHeader(rootView, insets: .scalable(30, 0, 0, 0))
        title.height = .scalable(80)
        
        table.fillHorizontally(rootView)
        table.top = title.bottom
        table.bottom = rootView.bottom
    }
    
    static func connect(props: inout Props, to storeState: CodingLoveState) {
        props.posts = storeState.posts
        props.loading = storeState.loading
        props.allPostsFetched = storeState.allPostsFetched
    }
}

