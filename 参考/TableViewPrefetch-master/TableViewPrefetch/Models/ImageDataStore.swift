//
//  ImageDataStore.swift
//  TableViewPrefetch
//
//  Created by Rokon Uddin on 12/7/18.
//  Copyright © 2018 Rokon Uddin. All rights reserved.
//

import Foundation
import UIKit.UIImage

let baseURL = "https://robohash.org/"

class ImageDataStore {
    private var images = (1...200)
        .map { ImageModel(url: baseURL+"\($0).png",
            order: $0) }
    public var numberOfImage: Int {
        return images.count
    }
    
    public func loadImage(at index: Int) -> DataLoadOperation? {
        if (0..<images.count).contains(index) {
            return DataLoadOperation(images[index])
        }
        return .none
    }
}

class DataLoadOperation: Operation {
    var image: UIImage?
    var loadingCompleteHandler: ((UIImage?) -> ())?
    private var _image: ImageModel
    
    init(_ image: ImageModel) {
        _image = image
    }
    
    override func main() {
        if isCancelled { return }
        guard let url = _image.url else { return }
        downloadImageFrom(url) { (image) in
            DispatchQueue.main.async() { [weak self] in
                guard let `self` = self else { return }
                if self.isCancelled { return }
                self.image = image
                self.loadingCompleteHandler?(self.image)
            }
        }
    }
}

func downloadImageFrom(_ url: URL, completeHandler: @escaping (UIImage?) -> ()) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard
            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
            let data = data, error == nil,
            let _image = UIImage(data: data)
            else { return }
        completeHandler(_image)
        }.resume()
}



