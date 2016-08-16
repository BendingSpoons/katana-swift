//
//  PlasticView.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

private enum ConstraintX {
  case None, Left, Right, CenterX, Width
}

private enum ConstraintY {
  case None, Top, Bottom, CenterY, Height
}

public class PlasticView {
  public let key: String
  
  private(set) var frame: CGRect
  private(set) var absoluteOrigin: CGPoint
  private let multiplier: CGFloat
  private unowned let hierarchyManager: HierarchyManager
  
  private var oldestConstraintX = ConstraintX.None
  private var newestConstraintX = ConstraintX.None
  private var oldestConstraintY = ConstraintY.None
  private var newestConstraintY = ConstraintY.None
  
  private var constraintX: ConstraintX {
    get {
      return newestConstraintX
    }
    
    set(newValue) {
      oldestConstraintX = newestConstraintX
      newestConstraintX = newValue
    }
  }
  
  private var constraintY: ConstraintY {
    get {
      return newestConstraintY
    }
    
    set(newValue) {
      oldestConstraintY = newestConstraintY
      newestConstraintY = newValue
    }
  }

  convenience init(key: String) {
    self.init(key: key, frame: CGRect.zero)
  }
  
  init(key: String, frame: CGRect) {
    self.key = key
    self.frame = frame
    self.absoluteOrigin = frame.origin
    self.multiplier = 1 //TODO: Implement me
  }
  
  private func scaleValue(_ value: Value) -> CGFloat {
    return value.scale(multiplier)
  }
}

// MARK: Update frame and absolute origin
extension PlasticView {
  private func updateHeight(_ newValue: CGFloat) -> Void {
    self.frame.size.height = newValue
  }
  
  private func updateWidth(_ newValue: CGFloat) -> Void {
    self.frame.size.width = newValue
  }
  
  private func updateX(_ newValue: CGFloat) -> Void {
    let relativeValue = self.hierarchyManager.relativeXCoordinate(newValue, forViewWithKey: self.key)
    self.frame.origin.x = relativeValue
    self.absoluteOrigin.x = newValue
  }
  
  private func updateY(_ newValue: CGFloat) -> Void {
    let relativeValue = self.hierarchyManager.relativeYCoordinate(newValue, forViewWithKey: self.key)
    self.frame.origin.y = relativeValue
    self.absoluteOrigin.y = newValue
  }
}

// MARK: Height
extension PlasticView {
  public var height: Value {
    get {
      return .Fixed(self.frame.size.height)
    }
    
    set(newValue) {
      setHeight(newValue)
    }
  }
  
  private func setHeight(_ value: Value) {
    self.constraintY = .Height
    
    let newHeight = max(scaleValue(value), 0)
    var newTop = self.top.coordinate
    
    if (oldestConstraintY == .Bottom) {
      newTop = self.bottom.coordinate - newHeight
    
    } else if (oldestConstraintY == .CenterY) {
      newTop = self.centerY.coordinate - newHeight / 2.0
    }
    
    self.updateY(newTop)
    self.updateHeight(newHeight)
  }
}

//class View {

//  public get width(): Value { return Value.fixed(this.frame.width); }
//  public get bottom(): Anchor { return new Anchor(Anchor.Kind.Bottom, this); }
//  public get top(): Anchor { return new Anchor(Anchor.Kind.Top, this); }
//  public get right(): Anchor { return new Anchor(Anchor.Kind.Right, this); }
//  public get left(): Anchor { return new Anchor(Anchor.Kind.Left, this); }
//  public get centerX(): Anchor { return new Anchor(Anchor.Kind.CenterX, this); }
//  public get centerY(): Anchor { return new Anchor(Anchor.Kind.CenterY, this); }
//  public get size(): Size { return Size.fixed(this.frame.width, this.frame.height); }
//  public get previousConstraintX(): ConstraintX { return this._constraintX.old };
//  public get previousConstraintY(): ConstraintY { return this._constraintY.old };
//  
//  public get css(): CSSLayoutT {
//  return {
//  position: 'absolute',
//  left: roundToNearestPixel(this.frame.left),
//  top: roundToNearestPixel(this.frame.top),
//  width: roundToNearestPixel(this.frame.width),
//  height: roundToNearestPixel(this.frame.height),
//  };
//  }
//  
//  // setters
//  public set constraintX(newConstraintX: ConstraintX) {
//  this._constraintX.old = this._constraintX.new;
//  this._constraintX.new = newConstraintX;
//  }
//  
//  public set constraintY(newConstraintY: ConstraintY) {
//  this._constraintY.old = this._constraintY.new;
//  this._constraintY.new = newConstraintY;
//  }
//  
//  public set size(newSize: Size) {
//  this.width = newSize.width;
//  this.height = newSize.height;
//  }
//  
//  public set left(v: Anchor) { this.setLeft(v); }
//  public set right(v: Anchor) { this.setRight(v); }
//  public set centerX(v: Anchor) { this.setCenterX(v); }
//  public set top(v: Anchor) { this.setTop(v); }
//  public set bottom(v: Anchor) { this.setBottom(v); }
//  public set centerY(v: Anchor) { this.setCenterY(v); }
//  public set hierarchy(v: HierarchyT) { this._hierarchy = v; }
//  
//  // complex setters
//  public set width(v: Value) {
//  this.constraintX = ConstraintX.Width;
//  
//  const newWidth = Math.max(this.scaleValue(v), 0.0);
//  let newLeft = this.left.coordinate();
//  
//  if (this._constraintX.old === ConstraintX.Right) {
//  newLeft = this.right.coordinate() - newWidth;
//  
//  } else if (this._constraintX.old === ConstraintX.CenterX) {
//  newLeft = this.centerX.coordinate() - newWidth / 2.0;
//  }
//  
//  // update coords
//  this.updateLeftCoordinate(newLeft);
//  this.frame.width = newWidth;
//  }
//  

//  
//  public setLeft(v: Anchor, o?: Value | number) {
//  const offset = scalableValueFromNumber(o);
//  
//  this.constraintX = ConstraintX.Left;
//  
//  const newLeft: number = v.coordinate() + this.scaleValue(offset);
//  let newWidth = this.scaleValue(this.width);
//  
//  if (this._constraintX.old === ConstraintX.Right) {
//  newWidth = Math.max(this.right.coordinate() - newLeft, 0);
//  
//  } else if (this._constraintX.old === ConstraintX.CenterX) {
//  newWidth = Math.max(2.0 * (this.centerX.coordinate() - newLeft), 0.0);
//  }
//  
//  // update coords
//  this.updateLeftCoordinate(newLeft);
//  this.frame.width = newWidth;
//  }
//  
//  public setRight(v: Anchor, o?: Value | number) {
//  const offset = scalableValueFromNumber(o);
//  
//  this.constraintX = View.ConstraintX.Right;
//  
//  const newRight = v.coordinate() + this.scaleValue(offset);
//  let newWidth = this.scaleValue(this.width);
//  
//  if (this.previousConstraintX === View.ConstraintX.Left) {
//  newWidth = Math.max(newRight - this.left.coordinate(), 0.0);
//  
//  } else if (this.previousConstraintX === View.ConstraintX.CenterX) {
//  newWidth = Math.max(2.0 * (newRight - this.centerX.coordinate()), 0.0);
//  }
//  
//  // update coords
//  this.updateLeftCoordinate(newRight - newWidth);
//  this.frame.width = newWidth;
//  }
//  
//  public setCenterX(v: Anchor, o?: Value | number) {
//  const offset = scalableValueFromNumber(o);
//  
//  this.constraintX = ConstraintX.CenterX;
//  
//  const newCenterX: number = v.coordinate() + this.scaleValue(offset);
//  let newWidth: number = this.scaleValue(this.width);
//  
//  if (this._constraintX.old === ConstraintX.Left) {
//  newWidth = Math.max(2.0 * (newCenterX - this.left.coordinate()), 0.0);
//  
//  } else if (this._constraintX.old === ConstraintX.Right) {
//  newWidth = Math.max(2.0 * (this.right.coordinate() - newCenterX), 0.0);
//  }
//  
//  // update coords
//  this.updateLeftCoordinate(newCenterX - newWidth / 2.0);
//  this.frame.width = newWidth;
//  }
//  
//  public setTop(v: Anchor, o?: Value | number) {
//  const offset = scalableValueFromNumber(o);
//  
//  this.constraintY = ConstraintY.Top;
//  
//  const newTop: number = v.coordinate() + this.scaleValue(offset);
//  let newHeight: number = this.scaleValue(this.height);
//  
//  if (this.constraintY === ConstraintY.Bottom) {
//  newHeight = Math.max(this.bottom.coordinate() - newTop, 0.0);
//  
//  } else if (this.constraintY === ConstraintY.CenterY) {
//  newHeight = Math.max(2.0 * (this.centerY.coordinate() - newTop), 0.0);
//  }
//  
//  // update coords
//  this.updateTopCoordinate(newTop);
//  this.frame.height = newHeight;
//  }
//  
//  public setBottom(v: Anchor, o?: Value | number) {
//  const offset = scalableValueFromNumber(o);
//  
//  this.constraintY = ConstraintY.Bottom;
//  
//  const newBottom: number = v.coordinate() + this.scaleValue(offset);
//  let newHeight: number = this.scaleValue(this.height);
//  
//  if (this._constraintY.old === ConstraintY.Top) {
//  newHeight = Math.max(newBottom - this.top.coordinate(), 0.0);
//  
//  } else if (this._constraintY.old === ConstraintY.CenterY) {
//  newHeight = Math.max(2.0 * (newBottom - this.centerY.coordinate()), 0.0);
//  }
//  
//  // update coords
//  this.updateTopCoordinate(newBottom - newHeight);
//  this.frame.height = newHeight;
//  }
//  
//  public setCenterY(v: Anchor, o?: Value | number) {
//  const offset = scalableValueFromNumber(o);
//  
//  this.constraintY = ConstraintY.CenterY;
//  
//  const newCenterY: number = v.coordinate() + this.scaleValue(offset);
//  let newHeight: number = this.scaleValue(this.height);
//  
//  if (this._constraintY.old === ConstraintY.Top) {
//  newHeight = Math.max(2.0 * (newCenterY - this.top.coordinate()), 0.0);
//  
//  } else if (this._constraintY.old === ConstraintY.Bottom) {
//  newHeight = Math.max(2.0 * (this.bottom.coordinate() - newCenterY), 0.0);
//  }
//  
//  // update coords
//  this.updateTopCoordinate(newCenterY - newHeight / 2.0);
//  this.frame.height = newHeight;
//  }
//  
//  // scalable methods
//  public scaleValue(v: Value): number { return v.totalValue(this.multiplier); }
//  public scaleFloat(f: number): number { return f * this.multiplier; }
//  public scaleAndRoundValue(v: Value): number { return Math.round(this.scaleValue(v)); }
//  public scaleAndRoundFloat(f: number): number { return Math.round(this.scaleFloat(f)); }
//  
//  // convenience methods
//  public fillViewHorizontally(view: View, insets: EdgeInsets = EdgeInsets.zero): void {
//  this.setLeft(view.left, insets.left);
//  this.setRight(view.right, insets.right.invertedValue());
//  }
//  
//  public fillViewVertically(view: View, insets: EdgeInsets = EdgeInsets.zero): void {
//  this.setTop(view.top, insets.top);
//  this.setBottom(view.bottom, insets.bottom.invertedValue());
//  }
//  
//  public fillView(view: View, insets: EdgeInsets = EdgeInsets.zero): void {
//  this.setLeft(view.left, insets.left);
//  this.setRight(view.right, insets.right.invertedValue());
//  this.setTop(view.top, insets.top);
//  this.setBottom(view.bottom, insets.bottom.invertedValue());
//  }
//  
//  public fillSpace(
//  top: Anchor,
//  left: Anchor,
//  bottom: Anchor,
//  right: Anchor,
//  aspectRatio: number = 1,
//  insets: EdgeInsets = EdgeInsets.zero
//  ) {
//  this.setLeft(left, insets.left);
//  this.setRight(right, insets.right.invertedValue());
//  this.setTop(top, insets.top);
//  this.setBottom(bottom, insets.bottom.invertedValue());
//  
//  const width = this.width.unscaledValue();
//  const height = this.height.unscaledValue();
//  
//  if (width / height < aspectRatio) {
//  this.centerBetweenTopAndBottom(top, bottom);
//  this.height = Value.fixed(width / aspectRatio);
//  
//  } else {
//  this.centerBetweenLeftAndRight(left, right);
//  this.width = Value.fixed(height * aspectRatio);
//  }
//  }
//  
//  public centerBetweenLeftAndRight(left: Anchor, right: Anchor): void {
//  this.setCenterX(
//  left,
//  Value.fixed((right.coordinate() - left.coordinate()) / 2.0)
//  );
//  }
//  
//  public centerBetweenTopAndBottom(top: Anchor, bottom: Anchor): void {
//  this.setCenterY(
//  top,
//  Value.fixed((bottom.coordinate() - top.coordinate()) / 2.0)
//  );
//  }
//  
//  public centerInView(view: View): void {
//  this.setCenterY(view.centerY);
//  this.setCenterX(view.centerX);
//  }
//  
//  public coverLeft(view: View, insets: EdgeInsets = EdgeInsets.zero) {
//  this.setLeft(view.left, insets.left);
//  this.setTop(view.top, insets.top);
//  this.setBottom(view.bottom, insets.bottom.invertedValue());
//  }
//  
//  public coverRight(view: View, insets: EdgeInsets = EdgeInsets.zero) {
//  this.setRight(view.right, insets.right.invertedValue());
//  this.setTop(view.top, insets.top);
//  this.setBottom(view.bottom, insets.bottom.invertedValue());
//  }
//  
//  public setAsHeader(view:View, insets: EdgeInsets = EdgeInsets.zero) {
//  this.setLeft(view.left, insets.left);
//  this.setRight(view.right, insets.right.invertedValue());
//  this.setTop(view.top, insets.top);
//  }
//  
//  public setAsFooter(view: View, insets: EdgeInsets = EdgeInsets.zero) {
//  this.setLeft(view.left, insets.left);
//  this.setRight(view.right, insets.right.invertedValue());
//  this.setBottom(view.bottom, insets.bottom.invertedValue());
//  }
//  
//  private getRelativeCoordinate = (
//  coord: 'left' | 'top',
//  absoluteCoordinate: number,
//  ): number => {
//  
//  const view = this._hierarchy[this.key];
//  invariant(view, `Cannot find a view representation with key ${this.key}`);
//  
//  if (!view.parent) {
//  return absoluteCoordinate;
//  
//  // TS is not able to understand if you pass "coord" as dict key
//  } else if (coord === 'left') {
//  return absoluteCoordinate - view.parent.absoluteOrigin.left;
//  
//  } else if (coord === 'top') {
//  return absoluteCoordinate - view.parent.absoluteOrigin.top;
//  }
//  
//  invariant(false, 'Something went wrong');
//  return -1;
//  }
//  
//  private updateLeftCoordinate = (absoluteValue: number) => {
//  const relativeValue = this.getRelativeCoordinate('left', absoluteValue);
//  this.absoluteOrigin.left = absoluteValue;
//  this.frame.left = relativeValue;
//  };
//  
//  private updateTopCoordinate = (absoluteValue: number) => {
//  const relativeValue = this.getRelativeCoordinate('top', absoluteValue);
//  this.absoluteOrigin.top = absoluteValue;
//  this.frame.top = relativeValue;
//  };
//}
//
//export default View;

//const scalableValueFromNumber = (v?: Value | number): Value => {
//  if (!v) {
//    return Value.zero;
//
//  } else if (typeof v === 'number') {
//    return Value.scalable(v);
//
//  } else {
//    return v;
//  }
//}
//

