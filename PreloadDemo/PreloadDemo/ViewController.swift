//
//  ViewController.swift
//  PreloadDemo
//
//  Created by shenjie on 2021/3/23.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate var tableView: UITableView!
    fileprivate var indicatorView: UIActivityIndicatorView!
    fileprivate var data:[Any]?
    fileprivate let threshold:CGFloat = 0.7
    fileprivate var currentPage:CGFloat = 0
    fileprivate var itemPerpage: Int = 10
    
    fileprivate var viewModel: PreloadCellViewModel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = PreloadCellViewModel()
        viewModel.delegate = self
       
        tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .white
        tableView.register(ProloadTableViewCell.self, forCellReuseIdentifier: "PreloadCellID")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        self.view.addSubview(tableView)
        
        indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.color = .red
        indicatorView.startAnimating()
        tableView.tableFooterView = indicatorView
        
        // 模拟请求图片
        viewModel.fetchImages()
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= (viewModel.currentCount - 1)
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
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PreloadCellID") as? ProloadTableViewCell else {
            fatalError("Sorry, could not load cell")
        }
        
        //        if isLoadingCell(for: indexPath) {
        //            cell.updateUI(.none, orderNo: "\(indexPath.row)")
        //        } else {
        //            cell.updateUI(.none, orderNo: "\(indexPath.row)")
        //        }
        
        cell.updateUI(.none, orderNo: "\(indexPath.row)")
        return cell
    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell(for:)){
            indicatorView.startAnimating()
            viewModel.fetchImages()
        }
    }

    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]){
        
    }
}

extension ViewController: PreloadCellViewModelDelegate {
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
//        guard let newIndexPathsToReload = newIndexPathsToReload else {
//            tableView.tableFooterView = nil
//            tableView.reloadData()
//            return
//        }
        
//        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
//        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
//        tableView.tableFooterView = nil
        
        indicatorView.stopAnimating()
        tableView.reloadData()
    }
    
    func onFetchFailed(with reason: String) {
//        tableView.tableFooterView = nil
        indicatorView.stopAnimating()
        tableView.reloadData()
    }
}

