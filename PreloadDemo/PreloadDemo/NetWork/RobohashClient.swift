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

