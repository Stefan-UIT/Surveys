//
//  UserLoginTests.swift
//  SurveysTests
//
//  Created by Trung Vo on 7/28/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import XCTest

@testable import Surveys

class UserLoginTests: XCTestCase {
    var userLogin:UserLogin!
    var stubService = ServicesStub()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        userLogin = UserLogin(provider: stubService)
    }
    // Test With Stub
    func testStubFetchTokenSuccess() {
        userLogin.username = DummyData.username
        userLogin.password = DummyData.password
        userLogin.requestAccessToken(success: {
            XCTAssertEqual(self.userLogin.token, DummyData.Response.token.accessToken)
        }) { (error) in
            XCTFail("Could Not Fetch Token with Stub")
        }
    }
    
    // Test With Stub
    func testStubFetchTokenFailed() {
        userLogin.username = ""
        userLogin.password = ""
        userLogin.requestAccessToken(success: {
            XCTFail("Could not success if there is invalid info")
        }) { (err) in
            let error = err as NSError
            XCTAssertEqual(error, DummyData.Response.error)
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        userLogin = nil
        super.tearDown()
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
