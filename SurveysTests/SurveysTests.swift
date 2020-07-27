//
//  SurveysTests.swift
//  SurveysTests
//
//  Created by Trung Vo on 7/23/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import XCTest
@testable import Surveys

class SurveysTests: XCTestCase {
    var survey:Survey!

    override func setUp() {
        super.setUp()
        survey = Survey()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testGetFullSizeImageCover() {
        survey.coverImageUrl = ""
        XCTAssertEqual(survey.fullSizeCoverImageUrl,"l")
    }

    override func tearDown() {
        
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
