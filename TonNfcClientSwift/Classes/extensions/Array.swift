
import Foundation

extension Array {
  
  subscript (range r: Range<Int>) -> Array {
    return Array(self[r])
  }
  
  
  subscript (range r: ClosedRange<Int>) -> Array {
    return Array(self[r])
  }
}
