
import Foundation

struct Moderator: Decodable {
  let displayName: String
  let reputation: String
  
  enum CodingKeys: String, CodingKey {
    case displayName = "display_name"
    case reputation
  }
  
  init(displayName: String, reputation: String) {
    self.displayName = displayName
    self.reputation = reputation
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let displayName = try container.decode(String.self, forKey: .displayName)
    let reputation = try container.decode(Double.self, forKey: .reputation)
    self.init(displayName: displayName.html2String, reputation: reputation.formatted)
  }
}
