//
//  Extensions.swift
//  NewsApp
//
//  Created by Alex Rudoi on 9/8/21.
//

import UIKit

extension UIImageView {
    func setDownloadedImage(from url: URL, contentMode mode: ContentMode = .scaleAspectFill, complition: @escaping () -> Void) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                complition()
            }
        }.resume()
    }
    func setDownloadedImage(from link: String, contentMode mode: ContentMode = .scaleAspectFill, complition: (() -> Void)? = nil) {
        guard let url = URL(string: link) else { return }
        setDownloadedImage(from: url, contentMode: mode) {
            complition?()
        }
    }
}
