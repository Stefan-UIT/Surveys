//
//  SurveysModelTests.swift
//  SurveysTests
//
//  Created by Trung Vo on 7/26/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import XCTest

@testable import Surveys

class SurveysModelTests: XCTestCase {
    var surveysModel:SurveysModel!

    override func setUpWithError() throws {
        super.setUp()
        surveysModel = SurveysModel()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        surveysModel = nil
        super.tearDown()
    }
    
    func test_AddSurveys() {
        let oldCount = surveysModel.count
        
        let survey = Survey(title: "title", description: "des", coverImageUrl: "https://dhdbhh0jsld0o.cloudfront.net/m/1ea51560991bcb7d00d0_")
        surveysModel.add(survey)
        
        XCTAssertEqual(surveysModel.count, oldCount + 1)
    }
    
    func test_FetchSurveysData() {
//        XCTAssertEqual(surveysModel.count, oldCount + 1)
    }
    


//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
