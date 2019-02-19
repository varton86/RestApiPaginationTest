//
//  UIImageView+Extensions.swift
//  TestTaskAlarStudios
//
//  Created by Oleg Soloviev on 29.01.2019.
//  Copyright © 2019 varton. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImage(fromURL url: String) -> URLSessionDataTask? {
        guard let imageURL = URL(string: url) else {
            return nil
        }
        var dataTask: URLSessionDataTask?
        let cache =  URLCache.shared
        let request = URLRequest(url: imageURL)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    guard let `self` = self else { return }
                    self.transition(toImage: image)
                }
            } else {
                dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        DispatchQueue.main.async {
                            guard let `self` = self else { return }
                            self.transition(toImage: image)
                        }
                    }
                })
                dataTask?.resume()
            }
        }
        return dataTask
    }
    
    func transition(toImage image: UIImage?) {
        UIView.transition(with: self, duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: { self.image = image },
                          completion: nil)
    }
}
