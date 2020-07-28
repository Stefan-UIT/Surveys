//
//  VerticalPageControlTests.swift
//  SurveysTests
//
//  Created by Trung Vo on 7/27/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import XCTest

@testable import Surveys

class VerticalPageControlTests: XCTestCase {
    
    var pageControl:VerticalPageControlView!
    

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        pageControl = VerticalPageControlView()
    }
    
    func testDisableScrollEnabledByDefault() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        pageControl = VerticalPageControlView.init(frame: frame)
        XCTAssertEqual(pageControl.frame, frame)
        XCTAssertFalse(pageControl.isScrollEnabled)
    }
    
    func testSetImageActiveState() {
        let image1 = UIImage(named: Images.ActivedDot)
        let image2 = UIImage(named: Images.InactivedDot)
        
        pageControl.setImageActiveState(image1, inActiveState: image2)
        XCTAssertEqual(pageControl.viewModel.activeImage, image1)
        XCTAssertEqual(pageControl.viewModel.inactiveImage, image2)
    }
    
    
    func testMoveUp() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 1000)
        let control = VerticalPageControlView(frame: frame)
        let contentOffset = CGPoint(x: 0, y: 50)
        control.contentOffset = contentOffset
        control.moveUp()
        XCTAssertLessThan(control.contentOffset.y, contentOffset.y)
    }
    
    func testMoveDown() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 1000)
        let control = VerticalPageControlView(frame: frame)
        let contentOffset = CGPoint(x: 0, y: 50)
        control.contentOffset = contentOffset
        control.moveDown()
        XCTAssertGreaterThan(control.contentOffset.y, contentOffset.y)
    }
    
    

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        pageControl = nil
        super.tearDown()
    }
    
//    func testImagesSetters() {
//        let image1 = UIImage(named: "image1")
//        let image2 = UIImage(named)
//    }

}
