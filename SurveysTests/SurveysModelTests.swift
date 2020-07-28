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
    var stubService = ServicesStub()

    override func setUp() {
        super.setUp()
        surveysModel = SurveysModel()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        surveysModel = nil
        super.tearDown()
    }
    
    
    // Test with real API
    func testFetchSurveysDataSuccess() {
        let token = UserLogin.shared.token
        XCTAssert(!token.isEmpty)
        
        let promise = expectation(description: "Fetch Surveys Data Success")
        surveysModel.fetchSurveys(success: {
            promise.fulfill()
        }) { (error) in
            XCTFail("Error: \(error.localizedDescription)")
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    // Test With Stub
    func testStubFetchSurveysDataSuccess() {
        surveysModel = SurveysModel(provider: stubService)
        surveysModel.fetchSurveys(success: {
            XCTAssertEqual(self.surveysModel.survey(at: 0).title, DummyData.survey1.title)
            XCTAssertEqual(self.surveysModel.survey(at: 1).title, DummyData.survey2.title)
        }) { (err) in
            XCTFail("Error \(err.localizedDescription)")
        }
    }
    
    func testStubFetchSurveysDataFailed() {
        surveysModel = SurveysModel(provider: stubService)
        stubService.isValidAccessToken = false
        surveysModel.fetchSurveys(success: {
            XCTFail("Could not success if there is invalid token")
        }) { (err) in
            let error = err as NSError
            XCTAssertEqual(error, DummyData.Response.error)
        }
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
