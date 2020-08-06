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
        guard let activeImage = activeImage, let inactiveImage = inactiveImage else { return nil }
        let button = UIButton(type: .custom)
        button.setImage(inactiveImage, for: .normal)
        button.setImage(activeImage, for: .selected)
        if let selector = selector, let target = target {
            button.addTarget(target, action: selector, for: .touchUpInside)
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
        let height = max(parentView.frame.height, parentView.contentSize.height)
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
