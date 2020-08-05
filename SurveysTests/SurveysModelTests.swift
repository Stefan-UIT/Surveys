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
    var surveysModel:SurveysViewModel!
    var stubService = ServicesStub()

    override func setUp() {
        super.setUp()
        surveysModel = SurveysViewModel()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        surveysModel = nil
        super.tearDown()
    }
    
    
    // Test With Stub
    func testStubFetchSurveysDataSuccess() {
        surveysModel = SurveysViewModel(provider: stubService)
        surveysModel.fetchSurveys(success: {
            XCTAssertEqual(self.surveysModel.survey(at: 0).title, DummyData.survey1.title)
            XCTAssertEqual(self.surveysModel.survey(at: 1).title, DummyData.survey2.title)
        }) { (err) in
            XCTFail("Error \(err.localizedDescription)")
        }
    }
    
    func testStubFetchSurveysDataFailed() {
        surveysModel = SurveysViewModel(provider: stubService)
        stubService.isValidAccessToken = false
        surveysModel.fetchSurveys(success: {
            XCTFail("Could not success if there is invalid token")
        }) { (err) in
            let error = err as NSError
            XCTAssertEqual(error, DummyData.Response.error)
        }
    }
}
