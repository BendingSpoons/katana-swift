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

  /// the offset at which this anchor will be set, with respect to the anchor it will be assigned to
  let offset: Value

  /**
   Creates an anchor with a given type, related to a specific `PlasticView`
   
   - parameter kind: the kind of the anchor
   - parameter view: the view the anchor pertains to
   - parameter offset: the offset at which this anchor will be set, with respect to the anchor it will be assigned to
  */
  init(kind: Kind, view: PlasticView, offset: Value = .zero) {
    self.kind = kind
    self.view = view
    self.offset = offset
  }
  
  /**
   As the `Anchor` instance symbolizes a line in a given view, this method will return that line's horizontal or vertical
   coordinate in the node description native view's coordinate system
  */
  var coordinate: CGFloat {
    let absoluteOrigin = self.view.absoluteOrigin
    let size = self.view.frame
    let coord: CGFloat

    switch self.kind {
    case .left:
      coord = absoluteOrigin.x
    
    case .right:
      coord = absoluteOrigin.x + size.width
    
    case .centerX:
      coord = absoluteOrigin.x + size.width / 2.0
      
    case .top:
      coord = absoluteOrigin.y
      
    case .bottom:
      coord = absoluteOrigin.y + size.height
      
    case .centerY:
      coord = absoluteOrigin.y + size.height / 2.0
      
    }

    return coord + view.scaleValue(offset)
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

  /**
   Create an anchor equal to `lhs`, but with an offset equal to `lhs.offset + rhs`
   */
  public static func + (lhs: Anchor, rhs: Value) -> Anchor {
    return Anchor(kind: lhs.kind, view: lhs.view, offset: lhs.offset + rhs)
  }

  /**
   Create an anchor equal to `lhs`, but with an offset equal to `lhs.offset - rhs`
   */
  public static func - (lhs: Anchor, rhs: Value) -> Anchor {
    return Anchor(kind: lhs.kind, view: lhs.view, offset: lhs.offset + -rhs)
  }

  /**
   Create an anchor equal to `lhs`, but with an offset equal to `lhs.offset + Value.scalable(rhs)`
   */
  public static func + (lhs: Anchor, rhs: CGFloat) -> Anchor {
    return lhs + .scalable(rhs)
  }

  /**
   Create an anchor equal to `lhs`, but with an offset equal to `lhs.offset - Value.scalable(rhs)`
   */
  public static func - (lhs: Anchor, rhs: CGFloat) -> Anchor {
    return lhs - .scalable(rhs)
  }
}
