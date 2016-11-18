//
//  HackerNews.swift
//  HackerNewsClient
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Katana
import KatanaElements

struct HackerNews: NodeDescription, PlasticNodeDescription, PlasticReferenceSizeable, ConnectedNodeDescription {
  typealias PropsType = Props
  typealias StateType = EmptyState
  typealias Keys = ChildrenKeys
  
  var props: PropsType
  static var referenceSize: CGSize = CGSize(width: 640, height: 960)
  
  static func childrenDescriptions(props: PropsType,
                                   state: StateType,
                                   update: @escaping (StateType) -> (),
                                   dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
  
    func reload() {
      dispatch(Reload(payload: ()))
    }
  
    var nodes: [AnyNodeDescription] = [
      Label(props: Label.Props.build({
        $0.setKey(Keys.titleLabel)
        $0.text = NSAttributedString(string: "HackerNews", attributes: [
          NSForegroundColorAttributeName: UIColor.white,
          NSFontAttributeName: UIFont.boldSystemFont(ofSize: 19)
          ])
        $0.textAlignment = NSTextAlignment.center
        $0.backgroundColor = UIColor(red:0.95, green:0.36, blue:0.13, alpha:1.00)
      })),
      Spinner(props: Spinner.Props.build({
        $0.setKey(Keys.spinner)
        $0.spinning = props.loading
      })),
      Button(props: Button.Props.build({
        let centerAlignmentParagraphStyle = NSMutableParagraphStyle()
        centerAlignmentParagraphStyle.alignment = .center
  
        $0.setKey(Keys.reloadButton)
        $0.titles = [ .normal: "Reload" ]
        $0.titleColors = [
          .normal: UIColor.white,
          .highlighted: UIColor(white: 1.0, alpha: 0.5)
        ]
        $0.backgroundColor = .clear
        $0.isEnabled = !props.loading
        $0.alpha = props.loading ? 0 : 1
        $0.touchHandlers = [
          .touchUpInside: reload
        ]
      })),
      Table(props: Table.Props.build({
        $0.setKey(Keys.table)
        $0.delegate = TableViewDelegate(posts: props.posts)
      })),
      Label(props: Label.Props.build({
        $0.setKey(Keys.emtpyText)
        $0.text = NSAttributedString(string: "Loading some posts...", attributes: [
          NSForegroundColorAttributeName: UIColor.gray,
          NSFontAttributeName: UIFont.systemFont(ofSize: 17)
          ])
        $0.textAlignment = NSTextAlignment.center
      }))
    ]
  
    if props.openPostURL != nil {
      let browser = Browser(props: Browser.Props.build({
        $0.setKey(Keys.browser)
        $0.url = props.openPostURL
        $0.alpha = (props.openPostURL == nil) ? 0 : 1
      }))

      nodes.append(browser)
    }
  
    return nodes
  }
  
  static func layout(views: ViewsContainer<Keys>,
                     props: PropsType,
                     state: StateType) {
    let root = views.nativeView
    let titleLabel =  views[.titleLabel]!
    let refreshButton = views[.reloadButton]!
    let spinner = views[.spinner]!
    let table = views[.table]!
    let emptyText = views[.emtpyText]!
    let browser = views[.browser]
  
    titleLabel.height = .scalable(80)
    titleLabel.asHeader(root, insets: .scalable(30, 0, 0, 0))
  
    refreshButton.fillVertically(titleLabel)
    refreshButton.width = .scalable(100)
    refreshButton.setRight(titleLabel.right, offset: .scalable(-10))
    
    spinner.center(refreshButton)
  
    table.fillHorizontally(root)
    table.top = titleLabel.bottom
    table.bottom = root.bottom
  
    if props.posts.isEmpty {
      emptyText.fill(table)
    }
  
    browser?.fill(root)
  }
  
  static func updateChildrenAnimations(container: inout ChildrenAnimations<ChildrenKeys>,
                                       currentProps: PropsType,
                                       nextProps: PropsType,
                                       currentState: StateType,
                                       nextState: StateType) {
    container[.browser] = Animation(
      type: .linear(duration: 0.3),
      entryTransformers: [AnimationProps.moveRight(distance: 320), AnimationProps.fade()],
      leaveTransformers: [AnimationProps.moveRight(distance: 320)]
    )
  }
  
  static func connect(props: inout HackerNews.Props, to storeState: HackerNewsState) {
    props.posts = storeState.posts
    props.loading = storeState.loading
    props.openPostURL = storeState.openPostURL
  }
}

extension HackerNews {
  enum ChildrenKeys {
    case titleLabel
    case spinner
    case table
    case reloadButton
    case emtpyText
    case browser
  }
  
  struct Props: NodeDescriptionProps, Buildable {
    var frame: CGRect = .zero
    var key: String?
    var alpha: CGFloat = 1.0
    
    var loading: Bool = false
    var posts: [Post] = []
    var openPostURL: URL?
  }
  
  struct TableViewDelegate: TableDelegate {
    var posts: [Post]
  
    func numberOfSections() -> Int {
      return 1
    }
  
    func numberOfRows(forSection section: Int) -> Int {
      return posts.count
    }
  
    func cellDescription(forRowAt indexPath: IndexPath) -> AnyNodeDescription {
      return PostCell(props: PostCell.PropsType.build({
        $0.index = indexPath.row
      }))
    }
  
    func height(forRowAt indexPath: IndexPath) -> Value {
      return .scalable(150)
    }
  
    func isEqual(to anotherDelegate: TableDelegate) -> Bool {
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
