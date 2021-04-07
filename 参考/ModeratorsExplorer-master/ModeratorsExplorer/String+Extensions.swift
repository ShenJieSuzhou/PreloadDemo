
import Foundation

extension String {
  var localizedString: String {
    return NSLocalizedString(self, comment: "")
  }
  
  var html2String: String {
    guard let data = data(using: .utf8), let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) else {
      return self
    }
    return attributedString.string
  }
}
