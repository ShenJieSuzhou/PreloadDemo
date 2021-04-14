//
//  RobohashClient.swift
//  PreloadDemo
//
//  Created by shenjie on 2021/4/2.
//

import UIKit

class ImageCache: NSObject {

    private var cache = NSCache<AnyObject, UIImage>()
    public static let shared = ImageCache()
    private override init() {}
   
    func getCache() -> NSCache<AnyObject, UIImage> {
       return cache
    }
}


class DataLoadOperation: Operation {
    var image: UIImage?
    var loadingCompleteHandle: ((UIImage?) -> ())?
    private var _image: ImageModel
    
    init(_ image: ImageModel) {
        _image = image
    }
    
    public final func getCacheImage(url: NSURL) -> UIImage? {
        return ImageCache.shared.getCache().object(forKey: url)
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
    func downloadImageFrom(_ url: URL, completeHandler: @escaping (UIImage?) -> ()) {
        // Check for a cached image.
        if let cachedImage = getCacheImage(url: url as NSURL) {
            print("命中缓存")
            DispatchQueue.main.async {
                completeHandler(cachedImage)
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let _image = UIImage(data: data)
                else { return }
            
            // Cache the image.
            ImageCache.shared.getCache().setObject(_image, forKey: url as NSURL)

            completeHandler(_image)
            }.resume()
    }
}


