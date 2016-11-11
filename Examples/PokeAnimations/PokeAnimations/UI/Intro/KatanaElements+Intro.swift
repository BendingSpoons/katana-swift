//
//  KatanaElements+Intro.swift
//  PokeAnimations
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.


import Foundation
import KatanaElements

extension View {
  static func pokemonBackground(for state: Intro.State.Step) -> View {
    
    let color: UIColor = {
      switch state {
      case .pokemon:
        return .charmender
      case .cute:
        return .eevee
      case .pokeball:
        return .pokeball
      case .gotcha:
        return .gotcha
      }
    }()
    
    return View(props: View.Props.build {
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
      case .cute:
        return #imageLiteral(resourceName: "eevee")
      case .pokeball:
        return #imageLiteral(resourceName: "pokeball")
      case .gotcha:
        return #imageLiteral(resourceName: "gotcha")
      }
    }()
    
    let key: Intro.ChildrenKeys = {
      switch state {
      case .pokemon:
        return .pokemonImage
      case .cute:
        return .cuteImage
      case .pokeball:
        return .pokeballImage
      case .gotcha:
        return .gotchaImage
      }
    }()
    
    return Image(props: Image.Props.build {
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
      case .cute:
        return "Aren't they cute?"
      case .pokeball:
        return "You can capture Pokémons using a Pokéball!\nAim, launch and capture"
      case .gotcha:
        return "All clear?\nThere is a world out there\nYour journey stars now!\nCatch'em All"
      }
    }()
    
    let key: Intro.ChildrenKeys = {
      switch state {
      case .pokemon:
        return .pokemonTitle
      case .cute:
        return .cuteTitle
      case .pokeball:
        return .pokeballTitle
      case .gotcha:
        return .gotchaTitle
      }
    }()
    
    return Label(props: Label.Props.build {
      $0.text = .paragraphString(content)
      $0.textAlignment = .center
      $0.numberOfLines = 0
      $0.backgroundColor = .clear
      $0.setKey(key)
    })
  }
}
