//
//  Intro.swift
//  PokeAnimations
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Katana
import KatanaElements

struct Intro: PlasticNodeDescription, PlasticReferenceSizeable {
  typealias PropsType = Props
  typealias StateType = State
  typealias NativeView = UIView
  typealias Keys = ChildrenKeys

  var props: PropsType

  static var referenceSize = CGSize(width: 480, height: 960)

  static func childrenDescriptions(props: PropsType,
                                   state: StateType,
                                   update: @escaping (StateType) -> (),
                                   dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {

    let didTap = { () -> () in
      update(state.step.next)
    }
    
    return [
      
      View.pokemonBackground(for: state.step),
      
      Button(props: ButtonProps.build { props in
        props.setKey(ChildrenKeys.button)
        props.backgroundColor = UIColor(white: 1, alpha: 0.4)
        props.cornerRadius = .scalable(20)
        props.borderWidth = .fixed(1)
        props.borderColor = .black
        props.attributedTitles = [
          .normal: .buttonTitleString("Next", for: .normal),
          .highlighted: .buttonTitleString("Next", for: .highlighted),
        ]
        
        props.touchHandlers = [
          .touchUpInside: didTap
        ]
      }),
      
      Image.pokemonImage(for: state.step),
      Label.pokemonTitle(for: state.step)
    
    ]
  }

  static func applyPropsToNativeView(props: PropsType,
                                     state: StateType,
                                     view: NativeView,
                                     update: @escaping (StateType)->(),
                                     node: AnyNode) {
    view.frame = props.frame
    view.alpha = props.alpha
    view.backgroundColor = .black
  }

  static func layout(views: ViewsContainer<Keys>, props: PropsType, state: StateType) {
    let nativeView = views.nativeView

    // button
    let button = views[.button]!
    button.asFooter(nativeView, insets: .scalable(0, 30, 30, 30))
    button.height = .scalable(80)
    
    // background
    let background = views[.background]
    background?.fill(nativeView)
    
    // images
    for key in ChildrenKeys.images {
      let image = views[key]
      image?.size = .scalable(250, 250)
      image?.centerX = views.nativeView.centerX
      image?.setTop(views.nativeView.top, offset: .scalable(100))
    }
    
    // titles
    for key in ChildrenKeys.titles {
      let title = views[key]
      title?.height = .scalable(200)
      title?.width = views.nativeView.width * 0.9
      title?.centerX = views.nativeView.centerX
      title?.setBottom(button.top, offset: .scalable(-100))
    }
  }
}

extension Intro {
  enum ChildrenKeys {
    case button, background
    
    case pokemonImage, pokemonTitle
    
    static var images: [ChildrenKeys] {
      return [
        .pokemonImage
      ]
    }
    
    static var titles: [ChildrenKeys] {
      return [
        .pokemonTitle
      ]
    }
  }
}

extension Intro {
  struct Props: NodeDescriptionProps {
    var alpha: CGFloat = 1.0
    var key: String?
    var frame: CGRect = .zero
    
    init(frame: CGRect) {
      self.frame = frame
    }
  }
}

extension Intro {
  struct State: NodeDescriptionState {
    enum Step {
      case pokemon, cute, pokeball, catchEmAll
      
      var next: State {
        switch self {
        case .pokemon:
          return State(step: .cute)
        case .cute:
          return State(step: .pokeball)
        case .pokeball:
          return State(step: .catchEmAll)
        case .catchEmAll:
          return State(step: .pokemon)
        }
      }
    }
    
    let step: Step
    
    init() { self.step = .pokemon }
    init(step: Step) { self.step = step }
  }
}

extension View {
  static func pokemonBackground(for state: Intro.State.Step) -> View {
    
    let color: UIColor = {
      switch state {
      case .pokemon:
        return .charmender
      default:
        fatalError()
      }
    }()
    
    return View(props: ViewProps.build {
      $0.backgroundColor = color
      $0.setKey(Intro.ChildrenKeys.background)
    })
  }
}

extension Image {
  static func pokemonImage(for state: Intro.State.Step) -> Image {
    
    let image: UIImage = {
      switch state {
      case .pokemon:
        return #imageLiteral(resourceName: "charmander")
      default:
        fatalError()
      }
    }()
    
    let key: Intro.ChildrenKeys = {
      switch state {
      case .pokemon:
        return .pokemonImage
      default:
        fatalError()
      }
    }()
    
    return Image(props: ImageProps.build {
      $0.image = image
      $0.backgroundColor = .clear
      $0.setKey(key)
    })
  }
}

extension Label {
  static func pokemonTitle(for state: Intro.State.Step) -> Label {
    
    let content: String = {
      switch state {
      case .pokemon:
        return "Hi Trainer!\nThis is a Pokémon!"
      default:
        fatalError()
      }
    }()
    
    let key: Intro.ChildrenKeys = {
      switch state {
      case .pokemon:
        return .pokemonTitle
      default:
        fatalError()
      }
    }()
    
    return Label(props: LabelProps.build {
      $0.text = .paragraphString(content)
      $0.textAlignment = .center
      $0.numberOfLines = 0
      $0.backgroundColor = .clear
      $0.setKey(key)
    })
  }
}
