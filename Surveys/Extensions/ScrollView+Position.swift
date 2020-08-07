//
//  ScrollView+Position.swift
//  Surveys
//
//  Created by Trung Vo on 7/25/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(bottomOffset, animated: true)
    }
    
    func scrollToTop() {
        let topOffset = CGPoint(x: 0, y: 0)
        setContentOffset(topOffset, animated: true)
    }
    
    func scrollTo(_ offset: CGPoint) {
        setContentOffset(offset, animated: true)
    }
}
