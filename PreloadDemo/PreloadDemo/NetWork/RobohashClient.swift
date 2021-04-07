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
    
    init(_ image: ImageModel) {
        _image = image
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
