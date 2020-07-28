//
//  VPCButtonHelper.swift
//  Surveys
//
//  Created by Trung Vo on 7/29/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import UIKit

// MARK: - VPCButtonHelper
struct VPCButtonHelper {
    func button(activeImage:UIImage?, inactiveImage:UIImage?, selector:Selector?, target:UIView?) -> UIButton? {
        guard let _activeImage = activeImage, let _inactiveImage = inactiveImage else { return nil }
        let button = UIButton(type: .custom)
        button.setImage(_inactiveImage, for: .normal)
        button.setImage(_activeImage, for: .selected)
        if let _selector = selector, let _target = target {
            button.addTarget(_target, action: _selector, for: .touchUpInside)
        }
        
        return button
    }
    
    func setPosition(ofButton button:UIButton, originY:CGFloat, itemSize:CGFloat, marginSpace:CGFloat, inView view:UIView) {
        let frame = CGRect(x: 0, y: originY, width: itemSize, height: (itemSize + marginSpace))
        button.frame = frame
        button.center = CGPoint(x: view.frame.width / 2.0, y: button.center.y)
        view.addSubview(button)
    }
    
    func handleSelectedState(ofButton button:UIButton, index:Int, currentPage:Int) {
        button.tag = index
        if index == currentPage {
            button.isSelected = true
            button.isUserInteractionEnabled = !button.isSelected
        }
    }
    
    func getY(itemSizeWithMarginSpace:CGFloat, parentView:UIScrollView, numberOfPages:Int) -> CGFloat {
        let contentHeight = parentView.contentSize.height
        let viewHeight = parentView.frame.height
        let height = max(viewHeight, contentHeight)
        return (height - (CGFloat(numberOfPages) * itemSizeWithMarginSpace)) / 2.0
    }
}

// MARK: - VPCPageHelper
struct VPCPageHelper {
    func calculatePage(contentOffsetY:CGFloat, pageHeight:CGFloat) -> Int {
        let page = Int((floor((contentOffsetY - pageHeight / 2) / pageHeight) + 1) + 1)
        return page
    }
    
    func pageNeedToUpdate(page:Int) -> Int {
        return (page == 0) ? 1 : page
    }
}
