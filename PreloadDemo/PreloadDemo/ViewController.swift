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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        self.view.addSubview(tableView)
        
        // 模拟请求图片
        let images = (1...200)
            .map { ImageModel(url: baseURL+"\($0).png",
                order: $0) }
//        public var numberOfImage: Int {
//            return images.count
//        }
//
//        public func loadImage(at index: Int) -> DataLoadOperation? {
//            if (0..<images.count).contains(index) {
//                return DataLoadOperation(images[index])
//            }
//            return .none
//        }
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
        return viewModel.numberOfImages
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID") as? ProloadTableViewCell else {
            fatalError("Sorry, could not load cell")
        }
       
        cell.updateUI(.none)
        return cell
    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }

    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]){
        
    }
}


