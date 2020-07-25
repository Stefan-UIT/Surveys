//
//  VerticalPageControlView.swift
//  Surveys
//
//  Created by Trung Vo on 7/24/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import UIKit

protocol VerticalPageControlViewDelegate:class {
    func verticalPageControlView(_ view: VerticalPageControlView?, currentPage: Int)
}

class VerticalPageControlView: UIScrollView {
    private var activeImage: UIImage?
    private var inactiveImage: UIImage?
    private var numberOfPages = 0   
    private var currentPage = 1
    private let marginSpace:Double = 10.0
    
    private var itemSize:CGSize {
        get {
            return activeImage?.size ?? CGSize.zero
        }
    }
    
    private var sizeWithSpace:Double {
        get {
            return Double(itemSize.width) + marginSpace
        }
    }

    weak var verticalPageControlDelegate: VerticalPageControlViewDelegate?

    func setImageActiveState(_ active: UIImage?, inActiveState inactive: UIImage?) {
        activeImage = active
        inactiveImage = inactive
    }

    func setNumberOfPages(_ pages: Int) {
        numberOfPages = pages
    }

    func setCurrentPage(_ current: Int) {
        currentPage = current
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.isScrollEnabled = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isScrollEnabled = false
    }
    

    func show() {
        if numberOfPages != 0 && numberOfPages > 0 && currentPage <= numberOfPages {
            if activeImage != nil && inactiveImage != nil {
                addStatesVertically()
                updateState(forPageNumber: currentPage)
            }
        }
    }

    func updateState(forPageNumber page: Int) {
        if page <= numberOfPages && numberOfPages != 0 && page != currentPage {
            let pageNeedToUpdate = (page == 0) ? 1 : page
            changeButtonState(forTag: pageNeedToUpdate)
        }
    }
    
    private func handleScrollingDown() {
        let shouldScrollToBottom = CGFloat(currentPage) * CGFloat(sizeWithSpace) + bounds.size.height >= contentSize.height
        if shouldScrollToBottom {
            scrollToBottom()
            return
        }
        moveDown()
    }
    
    private func handleScrollingUp() {
        let shouldScrollToTop = CGFloat(currentPage) * CGFloat(sizeWithSpace) - bounds.size.height <= 0
        if shouldScrollToTop {
            scrollToTop()
            return
        }
        moveUp()
    }
    
    private func updatePosition(forPageNumber page:Int) {
        // if user moving normal or click on the vertical page control
        let nextPage = CGFloat(page + 1)
        let nextPageY = nextPage * CGFloat(sizeWithSpace)
        let needToScrollDown = nextPageY > contentOffset.y + bounds.size.height
        
        if needToScrollDown {
            handleScrollingDown()
            return
        }
        
        let previousPage = CGFloat(page - 1)
        let previousPageY = previousPage * CGFloat(sizeWithSpace) - CGFloat(sizeWithSpace)
        let needToScrollUp = previousPageY < contentOffset.y
        
        if needToScrollUp {
            handleScrollingUp()
            return
        }
    }
    
    func proceed(contentOffsetY: CGFloat, pageHeight: CGFloat) {
        let page = Int((floor((contentOffsetY - pageHeight / 2) / pageHeight) + 1) + 1)
        updateState(forPageNumber: page)
        updatePosition(forPageNumber: page)
    }
    
    
    func moveDown() {
        let viewHeight = bounds.size.height - CGFloat(sizeWithSpace * 2)
        let nextContentOffset = CGPoint(x: contentOffset.x, y: contentOffset.y + viewHeight)
        self.setContentOffset(nextContentOffset, animated: true)
    }
    
    func moveUp() {
        let viewHeight = bounds.size.height - CGFloat(sizeWithSpace * 2)
        let nextContentOffset = CGPoint(x: contentOffset.x, y: contentOffset.y - viewHeight)
        self.setContentOffset(nextContentOffset, animated: true)
    }


// MARK: - Run time calculation / States Frame
    func stateVerticalFrameWith(x: CGFloat, y: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: itemSize.width, height: CGFloat(Double(itemSize.height) + marginSpace))
    }

    func getY() -> CGFloat {
        let dotHeight = CGFloat(Double(itemSize.height) + marginSpace)
        let contentHeight = contentSize.height
        let viewHeight = frame.height
        let height = max(viewHeight, contentHeight)
        return (height - (CGFloat(numberOfPages) * dotHeight)) / 2.0
    }

// MARK: - User tap / Delegate Call
    func callDelegate(forPageChange page: Int) {
        updateState(forPageNumber: page)
        if currentPage > 0 {
            self.verticalPageControlDelegate?.verticalPageControlView(self, currentPage: currentPage - 1)
        }
    }

    @objc func userTap(_ btnState: UIButton?) {
        callDelegate(forPageChange: btnState?.tag ?? 0)
    }

// MARK: - Add States
    
    private func removeAllSubViews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }
    
    private func calculateContentSize() {
        contentSize = .init(width: sizeWithSpace, height: sizeWithSpace * Double(numberOfPages))
    }

    private func addStatesVertically() {
        removeAllSubViews()
        calculateContentSize()
        var y = getY()
        for index in 1...numberOfPages {
            let dotButton = UIButton(type: .custom)
            dotButton.addTarget(self, action: #selector(userTap(_:)), for: .touchUpInside)
            dotButton.tag = index
            dotButton.setImage(inactiveImage, for: .normal)
            dotButton.setImage(activeImage, for: .selected)
            if index == currentPage {
                dotButton.isSelected = true
            }
            dotButton.frame = stateVerticalFrameWith(x: 0.0, y: y)
            addSubview(dotButton)
            dotButton.center = CGPoint(x: frame.width / 2.0, y: dotButton.center.y)
            y += dotButton.frame.size.height
        }
    }

// MARK: - Update States For State Change Event
    func changeButtonState(forTag tag: Int) {
        for index in 1...numberOfPages {
            let btnState = viewWithTag(index) as? UIButton
            btnState?.isSelected = false
            if index == tag {
                currentPage = index
                btnState?.isSelected = true
            }
        }
    }
}

