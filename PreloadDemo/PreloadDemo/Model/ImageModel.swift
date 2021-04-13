//
//  ImageModel.swift
//  PreloadDemo
//
//  Created by shenjie on 2021/4/2.
//

import Foundation

struct ImageModel {
    
    var url: NSURL?
    var order: Int?
    
    init(url: String, order: Int) {
        self.url = NSURL(string: url)
        self.order = order
    }
    
}
