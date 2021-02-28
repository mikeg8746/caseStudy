//
//  UIImageView+DownloadImage.swift
//  LeanScale
//
//  Created by Mayank G on 26/02/21.
//  Copyright © 2021 Mayank G. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImage(urlSting: String) {
        guard let url = URL(string: urlSting) else { return }
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlSting as AnyObject) {
            image = imageFromCache as? UIImage
            return
        }
        NetworkManager.downloadImage(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let imageToCache = UIImage(data: data) else { return }
                imageCache.setObject(imageToCache, forKey: urlSting as AnyObject)
                self.image = UIImage(data: data)
            case .failure(_):
                self.image = UIImage(named: "noImage.png")
            }
        }
    }
}
