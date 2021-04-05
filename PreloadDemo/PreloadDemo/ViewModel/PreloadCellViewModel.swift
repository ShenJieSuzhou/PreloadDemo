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
    
    func fetchImages() {
        guard !isFetchInProcess else {
            return
        }
        
        isFetchInProcess = true
        // 延时 3s 模拟网络环境
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 3) {
            self.currentPage += 1
            self.isFetchInProcess = false
            // 初始化 30个 图片
            let imagesData = (1...30).map {
                ImageModel(url: baseURL+"\($0).png", order: $0)
            }
            self.images.append(contentsOf: imagesData)
            self.total = self.images.count
            DispatchQueue.main.async {
                if self.currentPage > 1 {
                    let indexPathsToReload = self.calculateIndexPathsToReload(from: [])
                    self.delegate?.onFetchCompleted(with: indexPathsToReload)
                } else {
                    self.delegate?.onFetchFailed(with: "")
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
