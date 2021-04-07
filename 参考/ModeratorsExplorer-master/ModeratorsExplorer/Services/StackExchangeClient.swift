
import Foundation

final class StackExchangeClient {
  private lazy var baseURL: URL = {
    return URL(string: "http://api.stackexchange.com/2.2/")!
  }()
  
  let session: URLSession
  
  init(session: URLSession = URLSession.shared) {
    self.session = session
  }
  
  func fetchModerators(with request: ModeratorRequest, page: Int, completion: @escaping (Result<PagedModeratorResponse, DataResponseError>) -> Void) {
    
    let urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
    let parameters = ["page": "\(page)"].merging(request.parameters, uniquingKeysWith: +)
    let encodedURLRequest = urlRequest.encode(with: parameters)
    
    session.dataTask(with: encodedURLRequest, completionHandler: { (data, response, error) in
      guard
        let httpResponse = response as? HTTPURLResponse,
        httpResponse.hasSuccessStatusCode,
        let data = data
        else {
          completion(Result.failure(DataResponseError.network))
          return
      }
      
      guard let decodedResponse = try? JSONDecoder().decode(PagedModeratorResponse.self, from: data) else {
        completion(Result.failure(DataResponseError.decoding))
        return
      }
      
      completion(Result.success(decodedResponse))
      
      }).resume()
  }
}
