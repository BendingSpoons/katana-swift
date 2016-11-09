//
//  FetchMoreCell.swift
//  Katana
//
//  Created by Alain Caltieri on 07/11/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import Katana
import KatanaElements

extension FetchMoreCell {
    enum Keys: String {
        case label
    }
    
    struct Props: NodeDescriptionProps {
        var frame: CGRect = .zero
        var loading: Bool = true
        var allPostsFetched: Bool = false
    }
}


struct FetchMoreCell: PlasticNodeDescription, PlasticNodeDescriptionWithReferenceSize, TableCell, ConnectedNodeDescription  {
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
            Label(props: LabelProps.build({
                $0.key = Keys.label.rawValue
                $0.text = NSAttributedString(string: labelText, attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 16)
                    ])
                $0.textAlignment = .center
                $0.backgroundColor = labelBackgroundColor
            })),
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