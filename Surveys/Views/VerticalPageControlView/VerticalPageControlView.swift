//
//  VerticalPageControlView.swift
//  Surveys
//
//  Created by Trung Vo on 7/24/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import UIKit

// MARK: - VerticalPageControlViewDelegate
protocol VerticalPageControlViewDelegate:class {
    func verticalPageControlView(_ view: VerticalPageControlView?, currentPage: Int)
}

// MARK: - VerticalPageControlView
class VerticalPageControlView: UIScrollView {
    // MARK: - Private Var
    var viewModel = VPCViewModel()
    private let pageHelper = VPCPageHelper()
    weak var verticalPageControlDelegate: VerticalPageControlViewDelegate?
    
    // MARK: - Setters
    func setImageActiveState(_ active: UIImage?, inActiveState inactive: UIImage?) {
        viewModel.activeImage = active
        viewModel.inactiveImage = inactive
    }

    func setNumberOfPages(_ pages: Int) {
        viewModel.numberOfPages = pages
    }

    func setCurrentPage(_ current: Int) {
        viewModel.currentPage = current
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
    func show() throws {
        do {
            try viewModel.validateInputData()
        } catch let error {
            throw error
        }
        addStatesVertically()
        updateState(forPageNumber: viewModel.currentPage)
    }
    
    func proceed(contentOffsetY: CGFloat, pageHeight: CGFloat) {
        let page = pageHelper.calculatePage(contentOffsetY: contentOffsetY, pageHeight: pageHeight)
        updateState(forPageNumber: page)
        updatePosition(forPageNumber: page)
    }
    
    func moveDown() {
        let nextContentOffset = viewModel.getNextContentOffetToMoveDown(contentOffset: contentOffset, pageHeight: bounds.size.height)
        setContentOffset(nextContentOffset, animated: true)
    }
    
    func moveUp() {
        let nextContentOffset = viewModel.getNextContentOffetToMoveUp(contentOffset: contentOffset, pageHeight: bounds.size.height)
        self.setContentOffset(nextContentOffset, animated: true)
    }

    // MARK: - Private Methods
    private func updateState(forPageNumber page: Int) {
        do {
            try viewModel.validateInputData()
        } catch let error {
            let _error = error as! VPCValidationError
            print(_error.errorDescription)
            return
        }
        
        let isPageChanged = !viewModel.isSameCurrentPage(page: page)
        if isPageChanged {
            let pageNeedToUpdate = pageHelper.pageNeedToUpdate(page: page)
            changeButtonState(forTag: pageNeedToUpdate)
        }
    }
    
    private func handleScrollingDown() {
        let shouldScrollToBottom = viewModel.shouldScrollToBottom(pageHeight: bounds.size.height, pageContentSizeHeight: contentSize.height)
        if shouldScrollToBottom {
            scrollToBottom()
        } else {
            moveDown()
        }
    }
    
    private func handleScrollingUp() {
        let shouldScrollToTop = viewModel.shouldScrollToTop(pageHeight: bounds.size.height)
        if shouldScrollToTop {
            scrollToTop()
        } else {
            moveUp()
        }
    }
    
    private func updatePosition(forPageNumber page:Int) {
        let needToScrollDown = viewModel.needToScrollDown(pageContentOffsetY: contentOffset.y, pageHeight: bounds.size.height)
        if needToScrollDown {
            handleScrollingDown()
            return
        }
        
        let needToScrollUp = viewModel.needToScrollUp(pageContentOffsetY: contentOffset.y)
        if needToScrollUp {
            handleScrollingUp()
            return
        }
    }
    
    private func setupContentSize() {
        contentSize = viewModel.calculateContentSize()
    }

// MARK: - User tap / Delegate Call
    private func callDelegate(forPageChange page: Int) {
        updateState(forPageNumber: page)
        if viewModel.isValidCurrentPage {
            let index = viewModel.realTag
            self.verticalPageControlDelegate?.verticalPageControlView(self, currentPage: index)
        }
    }

    @objc func userTap(_ btnState: UIButton?) {
        let tag = btnState?.tag ?? 0
        callDelegate(forPageChange: tag)
    }

// MARK: - Add States
    private func addStatesVertically() {
        removeAllSubViews()
        setupContentSize()
        viewModel.addButtons(toView: self)
    }

// MARK: - Update States For State Change Event
    private func changeButtonState(forTag tag: Int) {
        viewModel.updateAllButtonsState(forTag: tag, inPageControl: self)
    }
}

