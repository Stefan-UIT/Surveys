//
//  VPCHelpersTests.swift
//  SurveysTests
//
//  Created by Trung Vo on 7/29/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import XCTest

@testable import Surveys

class VerticalPageControlViewMock:VerticalPageControlView {
    var isTapped = false
    
    override func userTap(_ btnState: UIButton?) {
        isTapped = true
    }
}

class VPCHelpersTests: XCTestCase {
    var pageHelper: VPCPageHelper!
    var buttonHelper:VPCButtonHelper!
    var pageControlMock:VerticalPageControlViewMock!
    let image1 = UIImage()
    let image2 = UIImage()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        pageHelper = VPCPageHelper()
        buttonHelper = VPCButtonHelper()
        pageControlMock = VerticalPageControlViewMock()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        pageHelper = nil
        buttonHelper = nil
        super.tearDown()
    }
    
    // MARK: - VPCButtonHelper
    func testWrongActiveImageName() {
        let button = buttonHelper.button(activeImage: nil, inactiveImage: image2, selector: nil, target: nil)
        XCTAssertNil(button)
    }
    
    func testWrongInactiveImageName() {
        let button = buttonHelper.button(activeImage: image1, inactiveImage: nil, selector: nil, target: nil)
        XCTAssertNil(button)
    }
    
    func testWrongActiveAndInactiveImageName() {
        let button = buttonHelper.button(activeImage: nil, inactiveImage: nil, selector: nil, target: nil)
        XCTAssertNil(button)
    }
    
    func testbuttonSetImageSuccess() {
        let button = buttonHelper.button(activeImage: image1, inactiveImage: image2, selector: nil, target: nil)
        guard let _button = button else {
            XCTFail("Error")
            return
        }
        
        let normalStateImage = _button.image(for: .normal)
        let selectedStateImage = _button.image(for: .selected)
        XCTAssertEqual(selectedStateImage, image1)
        XCTAssertEqual(normalStateImage, image2)
    }
    
    func testSetSelectorSuccess() {
        
        let button = buttonHelper.button(activeImage: image1, inactiveImage: image2, selector: #selector(pageControlMock.userTap(_:)), target: pageControlMock)
        
        button?.sendActions(for: .touchUpInside)
        XCTAssertTrue(pageControlMock.isTapped)
    }
    
    func testSetSelectorFailedWithNoTarget() {
        let button = buttonHelper.button(activeImage: image1, inactiveImage: image2, selector: #selector(pageControlMock.userTap(_:)), target: nil)
        button?.sendActions(for: .touchUpInside)
        
        XCTAssertFalse(pageControlMock.isTapped)
    }
    
    func testSetSelectorFailedWithNoSelector() {
        let button = buttonHelper.button(activeImage: image1, inactiveImage: image2, selector: nil, target: pageControlMock)
        button?.sendActions(for: .touchUpInside)
        
        XCTAssertFalse(pageControlMock.isTapped)
    }
    
    func testSetPositionSuccess() {
        let button = UIButton()
        let viewContainer = UIView()
        let y:CGFloat = 10
        let itemSize:CGFloat = 100
        let margin:CGFloat = 5
        buttonHelper.setPosition(ofButton: button, originY: y, itemSize: itemSize, marginSpace: margin, inView: viewContainer)
        XCTAssertEqual(button.frame.origin.y, y)
        XCTAssertEqual(button.frame.size.width, itemSize)
        XCTAssertEqual(button.frame.size.height, itemSize + margin)
    }
    
    func testHandleSelectedStateIndexEqualCurrentPage() {
        let button = UIButton()
        buttonHelper.handleSelectedState(ofButton: button, index: 1, currentPage: 1)
        XCTAssertTrue(button.isSelected)
        XCTAssertEqual(button.tag, 1)
    }
    
    func testHandleSelectedStateIndexDifferFromCurrentPage() {
        let button = UIButton()
        buttonHelper.handleSelectedState(ofButton: button, index: 4, currentPage: 5)
        XCTAssertFalse(button.isSelected)
        XCTAssertEqual(button.tag, 4)
    }
    
    func testGetY() {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        scrollView.contentSize = CGSize(width: 100, height: 1000)
        
        let y = buttonHelper.getY(itemSizeWithMarginSpace: 20, parentView: scrollView, numberOfPages: 10)
        XCTAssertEqual(y, 400)
    }
    
    // MARK: - VPCPageHelper
    func testCalculatePage() {
        let result = pageHelper.calculatePage(contentOffsetY: 100, pageHeight: 1000)
        XCTAssertEqual(result, 1)
    }
    
    func testPageNeedToUpdateEqualZero() {
        let result = pageHelper.pageNeedToUpdate(page: 0)
        XCTAssertEqual(result, 1)
    }
    
    func testPageNeedToUpdateGreaterThanZero() {
        let result = pageHelper.pageNeedToUpdate(page: 2)
        XCTAssertEqual(result, 2)
    }
}
