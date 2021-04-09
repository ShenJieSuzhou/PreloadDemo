//
//  PreloadCellViewModel.swift
//  PreloadDemo
//
//  Created by shenjie on 2021/4/2.
//

import UIKit
import Foundation

let baseURL = "https://robohash.org/"

protocol PreloadCellViewModelDelegate: NSObject {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

class PreloadCellViewModel: NSObject {
    var loadingQueue = OperationQueue()
    var loadingOperations = [IndexPath : DataLoadOperation]()
    
    weak var delegate: PreloadCellViewModelDelegate?
    
    private var images: [ImageModel] = []
    private var isFetchInProcess = false
    private var total = 0
    private var currentPage = 0
    
    let client = RobohashClient()
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return images.count
    }
        
    func imageModel(at index: Int) -> ImageModel {
        return images[index]
    }
    
    public func loadImage(at index: Int) -> DataLoadOperation? {
        if (0..<images.count).contains(index) {
            return DataLoadOperation(images[index])
        }
        return .none
    }
    
    func fetchImages() {
        guard !isFetchInProcess else {
            return
        }
        
        isFetchInProcess = true
        // 延时 2s 模拟网络环境
        print("+++++++++++ 模拟网络数据请求 +++++++++++")
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2) {
            print("+++++++++++ 模拟网络数据请求返回成功 +++++++++++")
            DispatchQueue.main.async {
                self.currentPage += 1
                self.isFetchInProcess = false
                // 初始化 30个 图片
                let imagesData = (1...30).map {
                    ImageModel(url: baseURL+"\($0).png", order: $0)
                }
                self.images.append(contentsOf: imagesData)
                self.total = self.images.count

                if self.currentPage > 1 {
                    let indexPathsToReload = self.calculateIndexPathsToReload(from: imagesData)
                    self.delegate?.onFetchCompleted(with: indexPathsToReload)
                } else {
                    self.delegate?.onFetchCompleted(with: .none)
                }
            }
        }
    }
    
    
    // 计算可视 indexPath 数组
    private func calculateIndexPathsToReload(from newImages: [ImageModel]) -> [IndexPath] {
        let startIndex = images.count - newImages.count
        let endIndex = startIndex + newImages.count
        
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0)}
    }
}
