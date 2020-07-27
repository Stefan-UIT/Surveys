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

enum VPCValidationError:Error {
    case InvalidNumberOfPage
    case InvalidCurrentPage
    case CurrentPageIsTooLarge
    case ActiveImageShouldNotNil
    case InActiveImageShouldNotNil
    
    
    var errorDescription: String {
        switch self {
        case .InvalidNumberOfPage:
            return Messages.InvalidNumberOfPages
        case .InvalidCurrentPage:
            return Messages.InvalidCurrentPage
        case .CurrentPageIsTooLarge:
            return Messages.CurrentPageShouldLessThanOrEqualNumberOfPage
        case .ActiveImageShouldNotNil:
            return Messages.ActiveImageShouldNotBeNil
        case .InActiveImageShouldNotNil:
            return Messages.InactiveImageShouldNotBeNil
        }
        
    }
}

struct VPCValidationService {
    func validateNumberOfPages(_ numberOfPages:Int) throws {
        guard numberOfPages > 0 else { throw VPCValidationError.InvalidNumberOfPage }
    }
    
    func validateCurrentPage(_ currentPage:Int, numberOfPages:Int) throws {
        guard currentPage > 0 else { throw VPCValidationError.InvalidCurrentPage }
        guard currentPage <= numberOfPages else { throw VPCValidationError.CurrentPageIsTooLarge }
    }
    
    func validateActiveImage(_ activeImage:UIImage?) throws {
        guard activeImage != nil else { throw VPCValidationError.ActiveImageShouldNotNil }
    }
    
    func validateInactiveImage(_ inactiveImage:UIImage?) throws {
        guard inactiveImage != nil else { throw VPCValidationError.InActiveImageShouldNotNil }
    }
}

class VerticalPageControlView: UIScrollView {
    // MARK: - Private Var
    var activeImage: UIImage?
    var inactiveImage: UIImage?
    var numberOfPages = 0
    var currentPage = 1
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
    
    private let validation = VPCValidationService()

    weak var verticalPageControlDelegate: VerticalPageControlViewDelegate?
    
    // MARK: - Setters
    func setImageActiveState(_ active: UIImage?, inActiveState inactive: UIImage?) {
        activeImage = active
        inactiveImage = inactive
    }

    func setNumberOfPages(_ pages: Int) {
        numberOfPages = pages
    }

    func setCurrentPage(_ current: Int) {
        if current <= numberOfPages {
            currentPage = current
        }
    }
    
    // MARK: - Init Functions
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.isScrollEnabled = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isScrollEnabled = false
    }
    
    // MARK: - Methods
    private func validateInputData() throws {
        do {
            try validation.validateNumberOfPages(numberOfPages)
            try validation.validateCurrentPage(currentPage, numberOfPages: numberOfPages)
            try validation.validateActiveImage(activeImage)
            try validation.validateInactiveImage(inactiveImage)
        } catch let error {
            throw error
        }
    }
    
    func show() throws {
        do {
            try validateInputData()
        } catch let error {
            throw error
        }
        
        addStatesVertically()
        updateState(forPageNumber: currentPage)
    }

    private func updateState(forPageNumber page: Int) {
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
    private func stateVerticalFrameWith(x: CGFloat, y: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: itemSize.width, height: CGFloat(Double(itemSize.height) + marginSpace))
    }

    private func getY() -> CGFloat {
        let dotHeight = CGFloat(Double(itemSize.height) + marginSpace)
        let contentHeight = contentSize.height
        let viewHeight = frame.height
        let height = max(viewHeight, contentHeight)
        return (height - (CGFloat(numberOfPages) * dotHeight)) / 2.0
    }

// MARK: - User tap / Delegate Call
    private func callDelegate(forPageChange page: Int) {
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
                // disable selected button to avoid multi click on selected button
                dotButton.isUserInteractionEnabled = !dotButton.isSelected
            }
            dotButton.frame = stateVerticalFrameWith(x: 0.0, y: y)
            addSubview(dotButton)
            dotButton.center = CGPoint(x: frame.width / 2.0, y: dotButton.center.y)
            y += dotButton.frame.size.height
        }
    }

// MARK: - Update States For State Change Event
    private func changeButtonState(forTag tag: Int) {
        for index in 1...numberOfPages {
            guard let _btnState = viewWithTag(index) as? UIButton else { break }
            _btnState.isSelected = false
            if index == tag {
                currentPage = index
                _btnState.isSelected = true
            }
            // disable selected button to avoid multi click on selected button
            _btnState.isUserInteractionEnabled = !_btnState.isSelected
        }
    }
}

