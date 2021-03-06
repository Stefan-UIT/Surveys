//
//  UIImageView+Extensions.swift
//  Surveys
//
//  Created by Trung Vo on 7/24/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func load(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        image = nil
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            image = imageFromCache
        } else {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data) {
                            imageCache.setObject(image, forKey: urlString as NSString)
                            self?.image = image
                        }
                    }
                }
                
            }
        }
        
    }
}
