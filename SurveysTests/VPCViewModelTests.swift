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
        viewModel.marginSpace = 10
        viewModel.numberOfPages = 5
        let size = viewModel.calculateContentSize()
        XCTAssertEqual(size, CGSize(width: 10, height: 50))
    }
    
    func testShouldScrollToBottomFase() {
        viewModel.numberOfPages = 10
        let pageControl = VerticalPageControlView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        pageControl.contentSize = CGSize(width: 100, height: 1000)
        XCTAssertFalse(viewModel.shouldScrollToBottom(pageControl: pageControl))
    }
    
    func testShouldScrollToBottomTrue() {
        viewModel.numberOfPages = 10
        let pageControl = VerticalPageControlView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        pageControl.contentSize = CGSize(width: 100, height: 100)
        XCTAssertTrue(viewModel.shouldScrollToBottom(pageControl: pageControl))
    }

}
