//
//  FetchMoreCell.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Katana
import KatanaElements

extension FetchMoreCell {
    enum Keys: String {
        case label
    }
    
    struct Props: NodeDescriptionProps {
        var key: String? = nil
        var alpha: CGFloat = 1.0
        var frame: CGRect = .zero
        var loading: Bool = true
        var allPostsFetched: Bool = false
    }
}

struct FetchMoreCell: PlasticNodeDescription, PlasticReferenceSizeable, TableCell, ConnectedNodeDescription {
    typealias StateType = EmptyHighlightableState
    typealias PropsType = Props
    typealias NativeView = NativeTableCell
    
    var props: Props
    
    static var referenceSize = CGSize(width: 640, height: 200)
    
    static func childrenDescriptions(props: PropsType,
                                     state: StateType,
                                     update: @escaping (StateType)->(),
                                     dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
        
        var labelText = "Fetch More"
        if props.loading {
            labelText = "Loading..."
        } else if props.allPostsFetched {
            labelText = "No more available"
        }
        
        var labelBackgroundColor = UIColor.white
        if state.highlighted {
            labelBackgroundColor = UIColor(colorLiteralRed: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        }
        
        return [
            Label(props: Label.Props.build({
                $0.key = Keys.label.rawValue
                $0.text = NSAttributedString(string: labelText, attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 16)
                    ])
                $0.textAlignment = .center
                $0.backgroundColor = labelBackgroundColor
            }))
        ]
    }
    
    static func layout(views: ViewsContainer<Keys>, props: Props, state: EmptyHighlightableState) {
        let rootView = views.nativeView
        let title = views[Keys.label]!
        
        title.fill(rootView)
    }
    
    static func didTap(dispatch: StoreDispatch, props: Props, indexPath: IndexPath) {
        if props.allPostsFetched {
            return
        }
        
        dispatch(FetchMorePosts(payload: ()))
    }

    static func connect(props: inout Props, to storeState: CodingLoveState) {
        props.loading = storeState.loading
        props.allPostsFetched = storeState.allPostsFetched
    }
}
