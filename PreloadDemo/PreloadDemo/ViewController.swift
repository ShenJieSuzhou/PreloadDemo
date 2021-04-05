//
//  ViewController.swift
//  PreloadDemo
//
//  Created by shenjie on 2021/3/23.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate var tableView: UITableView!
    fileprivate var data:[Any]?
    fileprivate let threshold:CGFloat = 0.7
    fileprivate var currentPage:CGFloat = 0
    fileprivate let itemPerpage: CGFloat = 10
    
    fileprivate var viewModel: PreloadCellViewModel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PreloadCellID")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        self.view.addSubview(tableView)
        
        // 模拟请求图片
        viewModel = PreloadCellViewModel()
        viewModel.delegate = self
//        viewModel.fetchImages()
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreloadCellID", for: indexPath) as! ProloadTableViewCell
        
        if isLoadingCell(for: indexPath) {
            cell.updateUI(.none, orderNo: "\(indexPath.row)")
        } else {
            cell.updateUI(.none, orderNo: "\(indexPath.row)")
        }

        return cell
    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }

    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]){
        
    }
}

extension ViewController: PreloadCellViewModelDelegate {
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            tableView.tableFooterView = nil
            tableView.reloadData()
            return
        }
        
        let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func onFetchFailed(with reason: String) {
        tableView.tableFooterView = nil
        tableView.reloadData()
    }
}

