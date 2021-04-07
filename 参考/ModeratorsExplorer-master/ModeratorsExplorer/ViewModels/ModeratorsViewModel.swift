
import Foundation

protocol ModeratorsViewModelDelegate: class {
  func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
  func onFetchFailed(with reason: String)
}

final class ModeratorsViewModel {
  private weak var delegate: ModeratorsViewModelDelegate?
  
  private var moderators: [Moderator] = []
  private var currentPage = 1
  private var total = 0
  private var isFetchInProgress = false
  
  let client = StackExchangeClient()
  let request: ModeratorRequest
  
  init(request: ModeratorRequest, delegate: ModeratorsViewModelDelegate) {
    self.request = request
    self.delegate = delegate
  }
  
  var totalCount: Int {
    return total
  }
  
  var currentCount: Int {
    return moderators.count
  }
  
  func moderator(at index: Int) -> Moderator {
    return moderators[index]
  }
  
  func fetchModerators() {
    guard !isFetchInProgress else {
      return
    }
    
    isFetchInProgress = true
    
    client.fetchModerators(with: request, page: currentPage) { (result) in
      switch result {
      case .failure(let error):
        DispatchQueue.main.async {
          self.isFetchInProgress = false
          self.delegate?.onFetchFailed(with: error.reason)
        }
      case .success(let response):
        DispatchQueue.main.async {
          self.currentPage += 1
          self.isFetchInProgress = false
          self.total = response.total
          self.moderators.append(contentsOf: response.moderators)
          if response.page > 1 {
            let indexPathsToReload = self.calculateIndexPathsToReload(from: response.moderators)
            self.delegate?.onFetchCompleted(with: indexPathsToReload)
          }
          else {
            self.delegate?.onFetchCompleted(with: .none)
          }
        }
      }
    }
  }
  
  private func calculateIndexPathsToReload(from newModerators: [Moderator]) -> [IndexPath] {
    let startIndex = moderators.count - newModerators.count
    let endIndex = startIndex + newModerators.count
    
    return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0)}
  }
}
