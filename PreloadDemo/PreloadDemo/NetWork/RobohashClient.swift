//
//  RobohashClient.swift
//  PreloadDemo
//
//  Created by shenjie on 2021/4/2.
//

import UIKit

class RobohashClient: NSObject {

    func fetchImageModels(_ url: URL, completehandler: @escaping (UIImage?) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                  let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                  let data = data, error == nil,
                  let _image = UIImage(data: data)
            else {
                return
            }
            completehandler(_image)
        }.resume()
    }
}


class DataLoadOperation: Operation {
    var image: UIImage?
    var loadingCompleteHandle: ((UIImage?) -> ())?
    private var _image: ImageModel
    private let cachedImages = NSCache<NSURL, UIImage>()
    
    init(_ image: ImageModel) {
        _image = image
    }
    
    public final func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        guard let url = _image.url else {
            return
        }
        downloadImageFrom(url) { (image) in
            DispatchQueue.main.async { [weak self] in
                guard let ss = self else { return }
                if ss.isCancelled { return }
                ss.image = image
                ss.loadingCompleteHandle?(ss.image)
            }
        }
        
    }
    
    // Returns the cached image if available, otherwise asynchronously loads and caches it.
    func downloadImageFrom(_ url: NSURL, completeHandler: @escaping (UIImage?) -> ()) {
        // Check for a cached image.
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                print("命中缓存")
                completeHandler(cachedImage)
            }
            return
        }
        
        URLSession.shared.dataTask(with: url as URL) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let _image = UIImage(data: data)
                else { return }
            // Cache the image.
            self.cachedImages.setObject(_image, forKey: url, cost: data.count)
            completeHandler(_image)
            }.resume()
    }
}


