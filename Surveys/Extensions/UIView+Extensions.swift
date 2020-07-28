//
//  UIView+Extensions.swift
//  Surveys
//
//  Created by Trung Vo on 7/28/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func removeAllSubViews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }
}
