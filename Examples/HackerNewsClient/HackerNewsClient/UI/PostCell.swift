//
//  PostCell.swift
//  HackerNewsClient
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Katana
import KatanaElements

struct PostCell: NodeDescription, PlasticNodeDescription, TableCell, ConnectedNodeDescription {
    typealias PropsType = Props
    typealias StateType = EmptyHighlightableState
    typealias Keys = ChildrenKeys
    
    var props: PropsType
    
    static func childrenDescriptions(props: PropsType,
                                     state: StateType,
                                     update: @escaping (StateType) -> (),
                                     dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
        
        return [
            View(props: View.Props.build({
                $0.setKey(ChildrenKeys.backgroundView)
                $0.backgroundColor = state.highlighted ? UIColor(white: 0, alpha: 0.1) : .white
            })),
            Label(props: Label.Props.build({
                $0.setKey(ChildrenKeys.titleLabel)
                $0.text = NSAttributedString(string: props.post!.title, attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight),
                    NSForegroundColorAttributeName: UIColor.black
                    ])
                $0.backgroundColor = .clear
                $0.numberOfLines = 0
            })),
            Label(props: Label.Props.build({
                $0.setKey(ChildrenKeys.pointsLabel)
                $0.text = NSAttributedString(string: String(props.post!.points), attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold),
                    NSForegroundColorAttributeName: UIColor.darkGray
                    ])
                $0.textAlignment = .center
                $0.backgroundColor = .clear
            }))
        ]
    }
    
    static func layout(views: ViewsContainer<Keys>,
                       props: PropsType,
                       state: StateType) {
        let root = views.nativeView
        let backgroundView = views[.backgroundView]!
        let titleLabel = views[.titleLabel]!
        let pointsLabel = views[.pointsLabel]!
        
        backgroundView.fill(root)
        
        pointsLabel.width = .scalable(100)
        pointsLabel.coverRight(root, insets: .scalable(0, 0, 0, 5))
        
        titleLabel.top = root.top
        titleLabel.bottom = root.bottom
        titleLabel.setLeft(root.left, offset: .scalable(15))
        titleLabel.setRight(pointsLabel.left, offset: .scalable(-5))
    }
    
    static func didTap(dispatch: (AnyAction) -> (), props: PostCell.Props, indexPath: IndexPath) {
        if let url = props.post?.url {
            dispatch(OpenPost(payload: url))
        }
    }
    
    static func connect(props: inout PostCell.Props, to storeState: HackerNewsState) {
        props.post = storeState.posts[props.index]
    }
}

extension PostCell {
    enum ChildrenKeys {
        case backgroundView
        case titleLabel
        case pointsLabel
    }

    struct Props: NodeDescriptionProps, Buildable {
        var frame: CGRect = .zero
        var key: String?
        var alpha: CGFloat = 1.0
        var index: Int = 0
        var post: Post? = nil
    }
    
    static func heightFor(titleText: String) -> CGFloat {
        return 0
    }
}
