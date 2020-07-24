//
//  UIImageView+Extensions.swift
//  Surveys
//
//  Created by Trung Vo on 7/24/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import UIKit

let imageCachess = NSCache<NSString, UIImage>()

extension UIImageView {
    func load(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        
        image = nil
        if let imageFromCache = imageCachess.object(forKey: urlString as NSString) {
            print("get from Cached")
            image = imageFromCache
        } else {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data) {
                            imageCachess.setObject(image, forKey: urlString as NSString)
                            print("download compelted + \(url)")
                            self?.image = image
                        }
                    }
                }
                
            }
        }
        
        
    }
}

