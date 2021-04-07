
import Foundation

struct ModeratorRequest {
  var path: String {
    return "users/moderators"
  }
  
  let parameters: Parameters
  private init(parameters: Parameters) {
    self.parameters = parameters
  }
}

extension ModeratorRequest {
  static func from(site: String) -> ModeratorRequest {
    let defaultParameters = ["order": "desc", "sort": "reputation", "filter": "!-*jbN0CeyJHb"]
    let parameters = ["site": "\(site)"].merging(defaultParameters, uniquingKeysWith: +)
    return ModeratorRequest(parameters: parameters)
  }
}
