//
//  Anchor.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

/**
 An abstract representation of a `PlasticView` layout property.
*/
public struct Anchor: Equatable {
  
  /// This enum represents the possible kinds of anchor
  public enum Kind {
    /// the left edge of the view the anchor pertains to
    case left
    /// the right edge of the view the anchor pertains to
    case right
    /// the horizontal center of the view the anchor pertains to
    case centerX
    /// the top edge of the view the anchor pertains to
    case top
    /// the bottom edge of the view the anchor pertains to
    case bottom
    /// the vertical center of the view the anchor pertains to
    case centerY
  }
  
  /// the kind of the anchor
  let kind: Kind
  
  /// the `PlasticView` to which the anchor is associated to
  let view: PlasticView
  
  /**
   Creates an anchor with a given type, related to a specific `PlasticView`
   
   - parameter kind: the kind of the anchor
   - parameter view: the view the anchor pertains to
  */
  init(kind: Kind, view: PlasticView) {
    self.kind = kind
    self.view = view
  }
  
  /**
   As the `Anchor` instance symbolizes a line in a given view, this method will return that line's horizontal or vertical
   coordinate in the node description native view's coordinate system
  */
  var coordinate: CGFloat {
    let absoluteOrigin = self.view.absoluteOrigin
    let size = self.view.frame
    
    switch self.kind {
    case .left:
      return absoluteOrigin.x
    
    case .right:
      return absoluteOrigin.x + size.width
    
    case .centerX:
      return absoluteOrigin.x + size.width / 2.0
      
    case .top:
      return absoluteOrigin.y
      
    case .bottom:
      return absoluteOrigin.y + size.height
      
    case .centerY:
      return absoluteOrigin.y + size.height / 2.0
      
    }
  }
  
  /**
   Implementation of the Equatable protocol
   
   - parameter lhs: the first anchor
   - parameter rhs: the second anchor
   - returns: true if the two anchors are equals, false otherwise. Two anchors are considered 
              equal if the are related to the same view and to they also have the same kind
  */
  public static func == (lhs: Anchor, rhs: Anchor) -> Bool {
    return lhs.kind == rhs.kind && lhs.view === rhs.view
  }
}
