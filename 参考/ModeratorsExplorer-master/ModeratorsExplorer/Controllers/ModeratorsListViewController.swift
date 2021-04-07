
import UIKit

// MARK: - ModeratorsListViewController

class ModeratorsListViewController: UIViewController, AlertDisplayer {
  private enum CellIdentifiers {
    static let list = "List"
  }
  
  @IBOutlet var indicatorView: UIActivityIndicatorView!
  @IBOutlet var tableView: UITableView!
  
  var site: String!
  
  private var viewModel: ModeratorsViewModel!
  
  private var shouldShowLoadingCell = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    indicatorView.color = ColorPalette.RWGreen
    
    tableView.tableFooterView = indicatorView
    tableView.separatorColor = ColorPalette.RWGreen
    tableView.dataSource = self
    tableView.prefetchDataSource = self
    
    let request = ModeratorRequest.from(site: site)
    viewModel = ModeratorsViewModel(request: request, delegate: self)
    
    viewModel.fetchModerators()    
  }
}

private extension ModeratorsListViewController {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.row >= viewModel.currentCount
  }
  
  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] { 
    let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
}

// MARK: - UITableViewDataSource
extension ModeratorsListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.totalCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.list, for: indexPath) as! ModeratorTableViewCell
    
    if isLoadingCell(for: indexPath) {
      cell.configure(with: .none)
    }
    else {
      cell.configure(with: viewModel.moderator(at: indexPath.row))
    }
    
    return cell
  }
}

// MARK: -  UITableViewDataSourcePrefetching

extension ModeratorsListViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    if indexPaths.contains(where: isLoadingCell(for:)) {
      viewModel.fetchModerators()
    }
  }
}

// MARK: - ModeratorsViewModelDelegate

extension ModeratorsListViewController: ModeratorsViewModelDelegate {
  func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
    guard let newIndexPathsToReload = newIndexPathsToReload else {
      tableView.tableFooterView = nil
      tableView.reloadData()
      return
    }
    let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
    tableView.reloadRows(at: indexPathsToReload, with: .automatic)
  }
  
  func onFetchFailed(with reason: String) {
    tableView.tableFooterView = nil
    tableView.reloadData()
    
    let title = "Warning".localizedString
    let action = UIAlertAction(title: "OK".localizedString, style: .default)
    displayAlert(with: title , message: reason, actions: [action])
  }
}


