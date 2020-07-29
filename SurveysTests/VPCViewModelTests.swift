//
//  VerticalPageControlViewModelTests.swift
//  SurveysTests
//
//  Created by Trung Vo on 7/29/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import XCTest

@testable import Surveys

class VPCViewModelTests: XCTestCase {
    var viewModel:VPCViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        viewModel = VPCViewModel()
        viewModel.currentPage = 1
        viewModel.marginSpace = 10
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        super.tearDown()
    }
    
    func testItemSizeIsNil() {
        viewModel.activeImage = nil
        XCTAssertEqual(viewModel.itemSize, CGSize.zero)
    }
    
    func testItemSizeHasValue() {
        let image = UIImage(named: Images.RefreshIcon)
        viewModel.activeImage = image
        XCTAssertNotEqual(viewModel.itemSize, CGSize.zero)
    }
    
    func testRealTag() {
        viewModel.currentPage = 100
        XCTAssertEqual(viewModel.realTag, 99)
    }
    
    func testAddButtonsSuccess() {
        let pageControl = VerticalPageControlView()
        viewModel.activeImage = UIImage()
        viewModel.inactiveImage = UIImage()
        viewModel.numberOfPages = 10
        let oldSubViewsCount = pageControl.subviews.count
        viewModel.addButtons(toView: pageControl)
        XCTAssertEqual(pageControl.subviews.count, oldSubViewsCount + 10)
    }
    
    func testCalculationContentSize() {
        viewModel.numberOfPages = 5
        let size = viewModel.calculateContentSize()
        XCTAssertEqual(size, CGSize(width: 10, height: 50))
    }
    
    func testShouldScrollToBottomReturnFalse() {
        viewModel.numberOfPages = 10
        XCTAssertFalse(viewModel.shouldScrollToBottom(pageHeight: 100, pageContentSizeHeight: 1000))
    }
    
    func testShouldScrollToBottomReturnTrue() {
        viewModel.numberOfPages = 10
        XCTAssertTrue(viewModel.shouldScrollToBottom(pageHeight: 100, pageContentSizeHeight: 100))
    }
    
    func testShouldScrollToTopReturnFalse() {
        viewModel.numberOfPages = 10
        XCTAssertFalse(viewModel.shouldScrollToTop(pageHeight: 5))
        
    }
    
    func testShouldScrollToTopReturnTrue() {
        viewModel.numberOfPages = 10
        XCTAssertTrue(viewModel.shouldScrollToTop(pageHeight: 50))
    }
    
    func testGetNextPage() {
        viewModel.currentPage = 3
        XCTAssertEqual(viewModel.nextPage, 4)
    }
    
    func testGetPreviousPage() {
        viewModel.currentPage = 3
        XCTAssertEqual(viewModel.previousPage, 2)
    }
    
    func testGetNextPageY() {
        viewModel.currentPage = 2
        XCTAssertEqual(viewModel.nextPageY, 30.0)
    }
    
    func testGetPreviousPageY() {
        viewModel.currentPage = 3
        XCTAssertEqual(viewModel.previousPageY, 10.0)
    }
    
    func testNeedToScrollDownReturnFalse() {
        viewModel.currentPage = 3
        XCTAssertFalse(viewModel.needToScrollDown(pageContentOffsetY: 10, pageHeight: 40))
    }
    
    func testNeedToScrollDownReturnTrue() {
        viewModel.currentPage = 3
        XCTAssertTrue(viewModel.needToScrollDown(pageContentOffsetY: 10, pageHeight: 5))
    }
    
    func testNeedToScrollUpReturnFalse() {
        viewModel.currentPage = 3
        XCTAssertFalse(viewModel.needToScrollUp(pageContentOffsetY: 5))
    }
    
    func testNeedToScrollUpReturnTrue() {
        viewModel.currentPage = 3
        XCTAssertTrue(viewModel.needToScrollUp(pageContentOffsetY: 15))
    }
    
    func testIsSamePageReturnFalse() {
        viewModel.currentPage = 5
        XCTAssertFalse(viewModel.isSameCurrentPage(page: 6))
    }
    
    func testIsSamePageReturnTrue() {
        viewModel.currentPage = 5
        XCTAssertTrue(viewModel.isSameCurrentPage(page: 5))
    }
    
    func testGetLimitedVisibleHeightSuccess() {
        XCTAssertEqual(viewModel.getLimitedVisibleHeight(pageHeight: 100), 80)
    }
    
    func testGetNextContentOffsetToMoveDownSuccess() {
//        let expectedPoint =
        let contentOffset = CGPoint(x: 0, y: 100)
        let nextContentOffset = viewModel.getNextContentOffetToMoveDown(contentOffset: contentOffset, pageHeight: 200)
        let expectedResult = CGPoint(x: 0, y: 280)
        XCTAssertEqual(nextContentOffset, expectedResult)
    }
    
    func testGetNextContentOffsetToMoveUpSuccess() {
        let contentOffset = CGPoint(x: 0, y: 200)
        let nextContentOffset = viewModel.getNextContentOffetToMoveUp(contentOffset: contentOffset, pageHeight: 100)
        let expectedResult = CGPoint(x: 0, y: 120)
        XCTAssertEqual(nextContentOffset, expectedResult)
    }
    
    func testUpdateSelectedStateTrue() {
        let button = UIButton()
        button.tag = 1
        viewModel.updateButtonState(button: button, atIndex: 1, forTag: 1)
        XCTAssertTrue(button.isSelected)
    }
    
    func testUpdateSelectedStateFalse() {
        let button = UIButton()
        button.tag = 2
        viewModel.updateButtonState(button: button, atIndex: 1, forTag: 2)
        XCTAssertFalse(button.isSelected)
    }
}
