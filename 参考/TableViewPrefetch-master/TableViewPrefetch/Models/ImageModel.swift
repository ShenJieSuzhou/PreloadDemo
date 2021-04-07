//
//  ImageModel.swift
//  TableViewPrefetch
//
//  Created by Rokon Uddin on 12/7/18.
//  Copyright © 2018 Rokon Uddin. All rights reserved.
//

import Foundation

struct ImageModel {
    public private(set) var url: URL?
    let order: Int
    
    init(url: String?, order: Int) {
        self.url = url?.toURL
        self.order = order
    }
}

public extension String {
    var toURL: URL? {
        return URL(string: self)
    }
}

