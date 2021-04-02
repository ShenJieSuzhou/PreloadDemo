//
//  ImageModel.swift
//  PreloadDemo
//
//  Created by shenjie on 2021/4/2.
//

import Foundation

struct ImageModel {
    
    fileprivate var url: URL?
    fileprivate var order: Int?
    
    init(url: String, order: Int) {
        self.url = URL(string: url)
        self.order = order
    }
    
}
