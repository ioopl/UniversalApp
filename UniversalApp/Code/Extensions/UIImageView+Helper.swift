//
//  UIImageView+Helper.swift
//  UniversalApp
//
//  Created by UHS on 26/02/2017.
//  Copyright © 2017 Apkia Technologies. All rights reserved.
//

import UIKit

// MARK: - Asynchronous Image Downloading Extension
// Source : http://stackoverflow.com/a/27712427/4326275

extension UIImageView {

    func downloadedFrom(link:String, contentMode mode: UIViewContentMode) {
        guard
            let url = NSURL(string: link)
            else {return}
        contentMode = mode
        URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
        }).resume()
    }
}
