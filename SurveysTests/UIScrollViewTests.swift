//
//  UIScrollViewTests.swift
//  SurveysTests
//
//  Created by Trung Vo on 7/27/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import XCTest

@testable import Surveys

class UIScrollViewTests: XCTestCase {
    var scrollView:UIScrollView!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        scrollView = UIScrollView(frame: frame)
    }
    
    func testScrollToBottom() {
        scrollView.scrollToBottom()
        let bottomY = scrollView.contentSize.height - scrollView.bounds.size.height
        XCTAssertEqual(scrollView.contentOffset.y, bottomY)
    }
    
    func testScrollToTop() {
        scrollView.scrollToTop()
        XCTAssertEqual(scrollView.contentOffset.y, 0)
    }
    
    func testScrollToOffset() {
        let contentOffset = CGPoint(x: 0, y: 50)
        scrollView.scrollTo(contentOffset)
        XCTAssertEqual(scrollView.contentOffset.y, contentOffset.y)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        scrollView = nil
        super.tearDown()
    }


}
