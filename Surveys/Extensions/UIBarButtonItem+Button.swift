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
    
    class func barButton(imageName: String, selector: Selector?, actionController:UIViewController?) -> UIBarButtonItem? {
        guard let button = UIButton.button(imageName: imageName, selector: selector, actionController: actionController) else { return nil }
        
        return UIBarButtonItem(customView: button)
    }
}

extension UIButton {
    class func button(imageName: String, selector: Selector?, actionController:UIViewController?) -> UIButton? {
        guard let image = UIImage(named: imageName) else { return nil }
        
        let itemSize:CGFloat = 30.0
        let constraintSize:CGFloat = 25.0
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: itemSize, height: itemSize)
        button.widthAnchor.constraint(equalToConstant: constraintSize).isActive = true
        button.heightAnchor.constraint(equalToConstant: constraintSize).isActive = true
        if let selector = selector, let controller = actionController {
            button.addTarget(controller, action: selector, for: .touchUpInside)
        }
        
        return button
    }
}
