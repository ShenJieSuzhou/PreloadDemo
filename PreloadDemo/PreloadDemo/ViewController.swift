//
//  ViewController.swift
//  PreloadDemo
//
//  Created by shenjie on 2021/3/23.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    fileprivate var tableView: UITableView!
    fileprivate var indicatorView: UIActivityIndicatorView!
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
        // preheat image ，处理将要显示的图像
//        guard let cell = cell as? ProloadTableViewCell else {
//            return
//        }
//
//        // 图片下载完毕后更新 cell
//        let updateCellClosure: (UIImage?) -> () = { [unowned self] (image) in
//            cell.updateUI(image, orderNo: "\(indexPath.row)")
//            viewModel.loadingOperations.removeValue(forKey: indexPath)
//        }
//
//        // 1. 首先判断是否已经存在创建好的下载线程
//        if let dataLoader = viewModel.loadingOperations[indexPath] {
//            if let image = dataLoader.image {
//                // 1.1 若图片已经下载好，直接更新
//                cell.updateUI(image, orderNo: "\(indexPath.row)")
//            } else {
//                // 1.2 若图片还未下载好，则等待图片下载完后更新 cell
//                dataLoader.loadingCompleteHandle = updateCellClosure
//            }
//        } else {
//            // 2. 没找到，则为指定的 url 创建一个新的下载线程
//            print("在 \(indexPath.row) 行创建一个新的图片下载线程")
//            if let dataloader = viewModel.loadImage(at: indexPath.row) {
//                // 2.1 添加图片下载完毕后的回调
//                dataloader.loadingCompleteHandle = updateCellClosure
//                // 2.2 启动下载
//                viewModel.loadingQueue.addOperation(dataloader)
//                // 2.3 将该下载线程加入到记录数组中以便根据索引查找
//                viewModel.loadingOperations[indexPath] = dataloader
//            }
//        }
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
        
        let updateCellClosure: (UIImage?) -> () = { [unowned self] (image) in
            cell.updateUI(image, orderNo: "\(indexPath.row)")
            viewModel.loadingOperations.removeValue(forKey: indexPath)
        }
        
        // 1. 首先判断是否已经存在创建好的下载线程
        if let dataLoader = viewModel.loadingOperations[indexPath] {
            if let image = dataLoader.image {
                // 1.1 若图片已经下载好，直接更新
                cell.updateUI(image, orderNo: "\(indexPath.row)")
            } else {
                // 1.2 若图片还未下载好，则等待图片下载完后更新 cell
                dataLoader.loadingCompleteHandle = updateCellClosure
            }
        } else {
            // 2. 没找到，则为指定的 url 创建一个新的下载线程
            print("在 \(indexPath.row) 行创建一个新的图片下载线程")
            if let dataloader = viewModel.loadImage(at: indexPath.row) {
                // 2.1 添加图片下载完毕后的回调
                dataloader.loadingCompleteHandle = updateCellClosure
                // 2.2 启动下载
                viewModel.loadingQueue.addOperation(dataloader)
                // 2.3 将该下载线程加入到记录数组中以便根据索引查找
                viewModel.loadingOperations[indexPath] = dataloader
            }
        }
        
        
//        cell.updateUI(.none, orderNo: "\(indexPath.row)")
        return cell
    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    // 翻页请求
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell(for:)){
            indicatorView.startAnimating()
            viewModel.fetchImages()
        }
    }

    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]){
        // 在不需要显示的时候，取消下载，避免造成资源浪费
        print("cancelPrefetchingForRowsAt \(indexPaths)")
        indexPaths.forEach {
            if let dataLoader = viewModel.loadingOperations[$0] {
                print("在 \($0.row) 行取消下载线程")
                dataLoader.cancel()
                viewModel.loadingOperations.removeValue(forKey: $0)
            }
        }
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

