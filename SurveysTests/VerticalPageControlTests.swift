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
    var validation:VPCValidationService!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        pageControl = VerticalPageControlView()
        validation = VPCValidationService()
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
        XCTAssertEqual(pageControl.activeImage, image1)
        XCTAssertEqual(pageControl.inactiveImage, image2)
    }
    
    func testValidNumberOfPages() {
        XCTAssertNoThrow(try validation.validateNumberOfPages(10))
    }
    
    func testInvalidNumberOfPages() {
        let expectedError = VPCValidationError.InvalidNumberOfPage
        var error: VPCValidationError?
        
        XCTAssertThrowsError(try validation.validateNumberOfPages(-1)) { (err) in
            error = err as? VPCValidationError
        }
        
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    func testValidCurrentPage() {
        XCTAssertNoThrow(try validation.validateCurrentPage(10, numberOfPages: 20))
    }
    
    func testValidActiveImage() {
        let image = UIImage(named: Images.ActivedDot)
        XCTAssertNoThrow(try validation.validateActiveImage(image))
    }
    
    
    func testValidInactiveImage() {
        let image = UIImage(named: Images.InactivedDot)
        XCTAssertNoThrow(try validation.validateActiveImage(image))
    }
    
    func testInvalidActiveImage() {
        let expectedError = VPCValidationError.ActiveImageShouldNotNil
        var error: VPCValidationError?
        
        XCTAssertThrowsError(try validation.validateActiveImage(nil)) { (err) in
            error = err as? VPCValidationError
        }
        
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    func testInvalidInactiveImage() {
        let expectedError = VPCValidationError.InActiveImageShouldNotNil
        var error: VPCValidationError?
        
        XCTAssertThrowsError(try validation.validateInactiveImage(nil)) { (err) in
            error = err as? VPCValidationError
        }
        
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    func testInvalidCurrentPage() {
        let expectedError = VPCValidationError.InvalidCurrentPage
        var error: VPCValidationError?
        
        XCTAssertThrowsError(try validation.validateCurrentPage(-1, numberOfPages: 5)) { (err) in
            error = err as? VPCValidationError
        }
        
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    func testCurrentPageLessThanNumberOfPages() {
        let expectedError = VPCValidationError.CurrentPageIsTooLarge
        var error: VPCValidationError?
        
        XCTAssertThrowsError(try validation.validateCurrentPage(999, numberOfPages: 10)) { (err) in
            error = err as? VPCValidationError
        }
        
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
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
        validation = nil
        super.tearDown()
    }
    
//    func testImagesSetters() {
//        let image1 = UIImage(named: "image1")
//        let image2 = UIImage(named)
//    }

}
