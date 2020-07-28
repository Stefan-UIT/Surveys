//
//  VPCValidationTests.swift
//  SurveysTests
//
//  Created by Trung Vo on 7/29/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import XCTest
@testable import Surveys

class VPCValidationTests: XCTestCase {
    
    var validation:VPCValidationService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        validation = VPCValidationService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        validation = nil
        super.tearDown()
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

}
