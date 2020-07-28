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
    
    // MARK: - Methods
    func getButton(withOriginY originY:CGFloat, atIndex index:Int, targetView:VerticalPageControlView) -> UIButton {
        let button = buttonHelper.button(activeImage: activeImage, inactiveImage: inactiveImage, selector: #selector(targetView.userTap(_:)), target: targetView)
        guard let _button = button  else {
            print(Messages.VPCCouldNotCreateButton)
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
    
    func shouldScrollToBottom(pageControl:VerticalPageControlView) -> Bool {
        let result = CGFloat(currentPage) * CGFloat(sizeWithSpace) + pageControl.bounds.size.height >= pageControl.contentSize.height
        return result
    }
    
    func shouldScrollToTop(pageControl:VerticalPageControlView) -> Bool {
        let result = CGFloat(currentPage) * CGFloat(sizeWithSpace) - pageControl.bounds.size.height <= 0
        return result
    }
    
    func needToScrollDown(pageControl:VerticalPageControlView) -> Bool {
        let nextPage = CGFloat(currentPage + 1)
        let nextPageY = nextPage * CGFloat(sizeWithSpace)
        let needToScrollDown = nextPageY > pageControl.contentOffset.y + pageControl.bounds.size.height
        return needToScrollDown
    }
    
    func needToScrollUp(pageControl:VerticalPageControlView) -> Bool {
        let previousPage = CGFloat(currentPage - 1)
        let previousPageY = previousPage * CGFloat(sizeWithSpace) - CGFloat(sizeWithSpace)
        let needToScrollUp = previousPageY < pageControl.contentOffset.y
        return needToScrollUp
    }
    
    func isSameCurrentPage(page:Int) -> Bool {
        return currentPage == page
    }
    
    func getNextContentOffetToMoveDown(contentOffset:CGPoint, pageHeight:CGFloat) -> CGPoint {
        let limitedVisibleHeight = pageHeight - CGFloat(sizeWithSpace * 2)
        let nextContentOffset = CGPoint(x: contentOffset.x, y: contentOffset.y + limitedVisibleHeight)
        return nextContentOffset
    }
    
    func getNextContentOffetToMoveUp(contentOffset:CGPoint, pageHeight:CGFloat) -> CGPoint {
        let limitedVisibleY = pageHeight - CGFloat(sizeWithSpace * 2)
        let nextContentOffset = CGPoint(x: contentOffset.x, y: contentOffset.y - limitedVisibleY)
        return nextContentOffset
    }
    
    
    mutating func updateButtonState(button:UIButton, atIndex index:Int, forTag tag:Int) {
        button.isSelected = false
        if index == tag {
            currentPage = index
            button.isSelected = true
        }
        // disable selected button to avoid multi click on selected button
        button.isUserInteractionEnabled = !button.isSelected
    }
    
    mutating func updateAllButtonsState(forTag tag: Int, inPageControl pageControl:VerticalPageControlView) {
        for index in 1...numberOfPages {
            guard let _btnState = pageControl.viewWithTag(index) as? UIButton else { break }
            updateButtonState(button: _btnState, atIndex: index, forTag: tag)
        }
    }
}
