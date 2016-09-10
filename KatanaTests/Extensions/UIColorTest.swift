import XCTest
@testable import Katana

class Color: XCTestCase {
  
  func testColor() {
    
    
    func getRGBAComponents(color: UIColor) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
      var (red, green, blue, alpha) = (CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.0))
      
      if color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
        return (red, green, blue, alpha)
      } else {
        return nil
      }
    }
    
    let white = UIColor(0x000000)
    XCTAssert( getRGBAComponents(color: white)!.red == 0)
    XCTAssert( getRGBAComponents(color: white)!.green == 0)
    XCTAssert( getRGBAComponents(color: white)!.blue == 0)
    XCTAssert( getRGBAComponents(color: white)!.alpha == 1)
    
    let black = UIColor(0xFFFFFF)
    XCTAssert( getRGBAComponents(color: black)!.red == 1)
    XCTAssert( getRGBAComponents(color: black)!.green == 1)
    XCTAssert( getRGBAComponents(color: black)!.blue == 1)
    XCTAssert( getRGBAComponents(color: black)!.alpha == 1)
    
    let red = UIColor(0xFF0000)
    XCTAssert( getRGBAComponents(color: red)!.red == 1)
    XCTAssert( getRGBAComponents(color: red)!.green == 0)
    XCTAssert( getRGBAComponents(color: red)!.blue == 0)
    XCTAssert( getRGBAComponents(color: red)!.alpha == 1)
  }
  
}
