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
    enum Keys: String {
        case tableView
        case titleLabel
    }
    
    struct Props: NodeProps, Buildable {
        var frame: CGRect = .zero
        var posts: [Post] = []
        var loading: Bool = true
        var allPostsFetched: Bool = false
    }
    
    struct TableViewDelegate: TableDelegate {
        var posts: [Post]
        var loading: Bool
        var allPostsFetched: Bool
        
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
                let post = posts[indexPath.row]
                return PostCell(props: PostCell.Props(frame: .zero, post: post))
            }

            return FetchMoreCell(props: FetchMoreCell.Props(frame: .zero, loading: loading, allPostsFetched: allPostsFetched))
        }
        
        public func height(forRowAt indexPath: IndexPath) -> Katana.Value {
            if indexPath.section == 0 {
                return Katana.Value(500)
            }
            return Katana.Value(100)
        }
        
        public func isEqual(to anotherDelegate: TableDelegate) -> Bool {
            if !(anotherDelegate is TableViewDelegate) {
                return false
            }
            
            let another = anotherDelegate as! TableViewDelegate
            
            if posts != another.posts {
                return false
            }
            
            if loading != another.loading {
                return false
            }
            
            if allPostsFetched != another.allPostsFetched {
                return false
            }
            
            return true
        }
    }
    
}


struct CodingLove: ConnectedNodeDescription, PlasticNodeDescription, PlasticNodeDescriptionWithReferenceSize {
    typealias StateType = EmptyState
    typealias PropsType = Props
    typealias NativeView = UIView
    
    var props: Props
    
    static var referenceSize: CGSize {
        return CGSize(width: 640, height: 960)
    }
    
    static func childrenDescriptions(props: PropsType,
                                     state: StateType,
                                     update: @escaping (StateType)->(),
                                     dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
        return [
            Label(props: LabelProps.build({
                $0.key = Keys.titleLabel.rawValue
                $0.text = NSAttributedString(string: "The Coding Love", attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 25)
                ])
                $0.textAlignment = NSTextAlignment.center
            })),
            Table(props: TableProps.build({
                $0.key = Keys.tableView.rawValue
                $0.delegate = TableViewDelegate(posts: props.posts, loading: props.loading, allPostsFetched: props.allPostsFetched)
            }))
        ]
    }
    
    static func layout(views: ViewsContainer<Keys>, props: Props, state: EmptyState) {
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

