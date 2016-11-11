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
      
      Button(props: ButtonProps.build {
        $0.setKey(ChildrenKeys.button)
        $0.backgroundColor = UIColor(white: 1, alpha: 0.4)
        $0.cornerRadius = .scalable(20)
        $0.borderWidth = .fixed(1)
        $0.borderColor = .black
        $0.attributedTitles = [
          .normal: .buttonTitleString(state.step == .gotcha ? "Restart": "Next", for: .normal),
          .highlighted: .buttonTitleString(state.step == .gotcha ? "Restart": "Next", for: .highlighted),
        ]
        
        $0.touchHandlers = [
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
  
  static func updateChildrenAnimations(container: inout ChildrenAnimations<Keys>,
                                       currentProps: PropsType,
                                       nextProps: PropsType,
                                       currentState: StateType,
                                       nextState: StateType) {

    container[.background] = Animation(type: .linear(duration: 0.3))
    
    
    // Pokemon slide
    container[.pokemonImage] = Animation(
      type: .linear(duration: 0.3),
      entryTransformers: [AnimationProps.fade()],
      leaveTransformers: [AnimationProps.scale(percentage: 0.0)]
    )
    
    container[.pokemonTitle] = Animation(
      type: .linear(duration: 0.3),
      entryTransformers: [AnimationProps.fade()],
      leaveTransformers: [AnimationProps.moveLeft(), AnimationProps.fade()]
    )
    
    // Cute slide
    container[.cuteImage] = Animation(
      type: .spring(duration: 0.5, damping: 0.4, initialVelocity: 0),
      entryTransformers: [AnimationProps.scale(percentage: 0.0)],
      leaveTransformers: [AnimationProps.moveLeft()]
    )
    
    container[.cuteTitle] = Animation(
      type: .linear(duration: 0.3),
      entryTransformers: [AnimationProps.moveRight(distance: 500), AnimationProps.fade()],
      leaveTransformers: [AnimationProps.moveLeft(distance: 500)]
    )
    
    // Pokeball slide
    container[.pokeballImage] = Animation(
      type: .linear(duration: 0.4),
      entryTransformers: [AnimationProps.scale(percentage: 0.0), AnimationProps.moveRight(distance: 300)],
      leaveTransformers: [AnimationProps.scale(percentage: 0.0), AnimationProps.moveLeft(distance: 300)]
    )
    
    container[.pokeballTitle] = Animation(
      type: .linear(duration: 0.3),
      entryTransformers: [AnimationProps.moveRight(distance: 300), AnimationProps.fade()],
      leaveTransformers: [AnimationProps.moveLeft(distance: 500)]
    )
    
    // gotcha slide
    container[.gotchaImage] = Animation(
      type: .linear(duration: 0.4),
      entryTransformers: [AnimationProps.fade()],
      leaveTransformers: [AnimationProps.fade()]
    )
    
    container[.gotchaTitle] = Animation(
      type: .linear(duration: 0.6),
      entryTransformers: [AnimationProps.fade()],
      leaveTransformers: [AnimationProps.fade()]
    )
  }
}

extension Intro {
  enum ChildrenKeys {
    case button, background
    case pokemonImage, pokemonTitle
    case cuteImage, cuteTitle
    case pokeballImage, pokeballTitle
    case gotchaImage, gotchaTitle
    
    static var images: [ChildrenKeys] {
      return [
        .pokemonImage, .cuteImage, .pokeballImage, .gotchaImage
      ]
    }
    
    static var titles: [ChildrenKeys] {
      return [
        .pokemonTitle, cuteTitle, .pokeballTitle, .gotchaTitle
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
      case pokemon, cute, pokeball, gotcha
      
      var next: State {
        switch self {
        case .pokemon:
          return State(step: .cute)
        case .cute:
          return State(step: .pokeball)
        case .pokeball:
          return State(step: .gotcha)
        case .gotcha:
          return State(step: .pokemon)
        }
      }
    }
    
    let step: Step
    
    init() { self.step = .pokemon }
    init(step: Step) { self.step = step }
  }
}
