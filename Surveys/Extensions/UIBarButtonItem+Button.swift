//
//  UIBarButtonItem+Button.swift
//  Surveys
//
//  Created by Trung Vo on 7/25/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    class func barButton(imageName: String, selector: Selector?, actionController:UIViewController?) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        if let _selector = selector, let _controller = actionController {
            button.addTarget(_controller, action: _selector, for: .touchUpInside)
        }
        return UIBarButtonItem(customView: button)
    }
}
