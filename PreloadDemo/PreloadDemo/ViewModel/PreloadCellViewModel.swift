//
//  PreloadCellViewModel.swift
//  PreloadDemo
//
//  Created by shenjie on 2021/4/2.
//

import UIKit

let baseURL = "https://robohash.org/"

class PreloadCellViewModel: NSObject {
    
    private var images: [ImageModel] = []
    private var isFetchInProcess = false
    private var total = 0
    
    let client = RobohashClient()
    
    var totalCount: Int {
        return total
    }
    
    func fetchImages() {
        guard !isFetchInProcess else {
            return
        }
    }
    
    // 计算可视 indexPath 数组
    private func calculateIndexPathsToReload(from newImages: [ImageModel]) -> [IndexPath] {
        
        return []
    }
}
