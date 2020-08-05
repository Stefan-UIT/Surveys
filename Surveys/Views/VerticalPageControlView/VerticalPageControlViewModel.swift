//
//  VerticalPageControlViewModel.swift
//  Surveys
//
//  Created by Trung Vo on 7/28/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import UIKit

// MARK: - VPCViewModel
struct VPCViewModel {
    // MARK: - Variables
    var activeImage: UIImage?
    var inactiveImage: UIImage?
    var numberOfPages = 0
    var currentPage = 1
    var marginSpace:CGFloat = 10.0
    
    let validation = VPCValidationService()
    private let buttonHelper = VPCButtonHelper()
    
    
    // MARK: - Getter Variables
    var itemSize:CGSize {
        get {
            return activeImage?.size ?? CGSize.zero
        }
    }
    
    var sizeWithSpace:CGFloat {
        get {
            return (itemSize.width + marginSpace)
        }
    }
    
    var realTag:Int {
        get {
            return currentPage - 1
        }
    }
    
    var isValidCurrentPage:Bool {
        get {
            do {
                try validation.validateCurrentPage(currentPage, numberOfPages: numberOfPages)
                return true
            } catch {
                return false
            }
        }
    }
    
    var nextPage:Int {
        get {
            return currentPage + 1
        }
    }
    
    var previousPage:Int {
        get {
            return currentPage - 1
        }
    }
    
    var nextPageY:CGFloat {
        get {
            return CGFloat(self.nextPage) * CGFloat(sizeWithSpace)
        }
    }
    
    var previousPageY:CGFloat {
        get {
            return CGFloat(self.previousPage) * sizeWithSpace - sizeWithSpace
        }
    }
    
    // MARK: - Methods
    mutating func resetData() {
        numberOfPages = 0
        currentPage = 1
    }
    
    func validateInputData() throws {
        do {
            try validation.validateNumberOfPages(numberOfPages)
            try validation.validateCurrentPage(currentPage, numberOfPages: numberOfPages)
            try validation.validateActiveImage(activeImage)
            try validation.validateInactiveImage(inactiveImage)
        } catch let error {
            throw error
        }
    }
    
    func getButton(withOriginY originY:CGFloat, atIndex index:Int, targetView:VerticalPageControlView) -> UIButton {
        let button = buttonHelper.button(activeImage: activeImage, inactiveImage: inactiveImage, selector: #selector(targetView.userTap(_:)), target: targetView)
        guard let _button = button  else {
            return UIButton()
        }
        buttonHelper.setPosition(ofButton: _button, originY: originY, itemSize: itemSize.width, marginSpace: CGFloat(marginSpace), inView: targetView)
        buttonHelper.handleSelectedState(ofButton: _button, index: index, currentPage: currentPage)
        return _button
    }
    
    func addButtons(toView view:VerticalPageControlView) {
        var y = buttonHelper.getY(itemSizeWithMarginSpace: sizeWithSpace, parentView: view, numberOfPages: numberOfPages)
        for index in 1...numberOfPages {
            let button = getButton(withOriginY: y, atIndex: index, targetView: view)
            y += button.frame.size.height
        }
    }
    
    func calculateContentSize() -> CGSize {
        return CGSize(width: sizeWithSpace, height: sizeWithSpace * CGFloat(numberOfPages))
    }
    
    func shouldScrollToBottom(pageHeight:CGFloat, pageContentSizeHeight:CGFloat) -> Bool {
        let result = CGFloat(currentPage) * CGFloat(sizeWithSpace) + pageHeight >= pageContentSizeHeight
        return result
    }
    
    func shouldScrollToTop(pageHeight:CGFloat) -> Bool {
        let result = CGFloat(currentPage) * CGFloat(sizeWithSpace) - pageHeight <= 0
        return result
    }
    
    func needToScrollDown(pageContentOffsetY:CGFloat, pageHeight:CGFloat) -> Bool {
        let needToScrollDown = self.nextPageY > pageContentOffsetY + pageHeight
        return needToScrollDown
    }
    
    func needToScrollUp(pageContentOffsetY:CGFloat) -> Bool {
        let needToScrollUp = self.previousPageY < pageContentOffsetY
        return needToScrollUp
    }
    
    func isSameCurrentPage(page:Int) -> Bool {
        return currentPage == page
    }
    
    func getLimitedVisibleHeight(pageHeight:CGFloat) -> CGFloat {
        return pageHeight - CGFloat(sizeWithSpace * 2)
    }
    
    func getNextContentOffetToMoveDown(contentOffset:CGPoint, pageHeight:CGFloat) -> CGPoint {
        let limitedVisibleHeight = getLimitedVisibleHeight(pageHeight: pageHeight)
        let nextContentOffset = CGPoint(x: contentOffset.x, y: contentOffset.y + limitedVisibleHeight)
        return nextContentOffset
    }
    
    func getNextContentOffetToMoveUp(contentOffset:CGPoint, pageHeight:CGFloat) -> CGPoint {
        let limitedVisibleY = getLimitedVisibleHeight(pageHeight: pageHeight)
        let nextContentOffset = CGPoint(x: contentOffset.x, y: contentOffset.y - limitedVisibleY)
        return nextContentOffset
    }
    
    // MARK: - Mutating Methods
    mutating func updateButtonState(button:UIButton, atIndex index:Int, forTag tag:Int) {
        let isShouldSelected = (index == tag)
        button.isSelected = isShouldSelected
        button.isUserInteractionEnabled = !button.isSelected
        if isShouldSelected {
            currentPage = index
        }
    }
    
    mutating func updateAllButtonsState(forTag tag: Int, inPageControl pageControl:VerticalPageControlView) {
        for index in 1...numberOfPages {
            guard let _btnState = pageControl.viewWithTag(index) as? UIButton else { break }
            updateButtonState(button: _btnState, atIndex: index, forTag: tag)
        }
    }
}
