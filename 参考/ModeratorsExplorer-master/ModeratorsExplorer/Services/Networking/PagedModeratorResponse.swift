
import Foundation

struct PagedModeratorResponse: Decodable {
  let moderators: [Moderator]
  let total: Int
  let hasMore: Bool
  let page: Int
  
  enum CodingKeys: String, CodingKey {
    case moderators = "items"    
    case hasMore = "has_more"
    case total
    case page
  }
}
