
import Foundation

extension Double {
  static let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = NumberFormatter.Style.decimal
    return formatter
  }()
  
  var formatted: String {
    return Double.formatter.string(for: self) ?? String(self)
  }
}
