//
//  APIServicesTests.swift
//  SurveysTests
//
//  Created by Trung Vo on 7/27/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import XCTest

@testable import Surveys

class APIServicesTests: XCTestCase {
    var services:APIServices!
    let testedToken:String = "b1c2bf9e540f67fc2a390f2e4cfe41c69b0fd43c16f0cce0f8e50ec0ca025cf7"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        services = APIServices.shared
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetHeader() {
        let header = services.getHeader()
        XCTAssert(header.count > 1)
        
        let contentType = header.value(for: K.ContentType)
        let acceptType = header.value(for: K.Accept)
        XCTAssertEqual(contentType, K.ApplicationJson)
        XCTAssertEqual(acceptType, K.ApplicationJson)
    }
    
    func testBearerTokenInHeader() {
        UserLogin.shared.token = testedToken
        let header = services.getHeader()
        guard let bearerToken = header.value(for: K.Authorization) else {
            XCTFail()
            return
        }
        XCTAssert(bearerToken.contains("Bearer"))
    }
    
    func testFetchSurveysDataSuccess() {
        UserLogin.shared.token = testedToken
        
        let promise = expectation(description: "Fetch Surveys Data Success")
        services.fetchSurveys(page: 1, success: { (surveys) in
            XCTAssertNotNil(surveys, "surveys is nil")
            promise.fulfill()
        }) { (error) in
            XCTFail("Error: \(error.localizedDescription)")
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testFetchSurveysDataFailed() {
        UserLogin.shared.token = ""
        
        let promise = expectation(description: "Fetch Surveys Data Failed")
        services.fetchSurveys(page: 1, success: { (surveys) in
            XCTFail("API should not response success without access token")
        }) { (error) in
            XCTAssertNotNil(error , "there is no error")
            promise.fulfill()
        }
        wait(for: [promise], timeout: 30)
    }
    
    func testGetAccessTokenSuccess() {
        let username = "carlos@nimbl3.com"
        let password = "antikera"
        
        let promise = expectation(description: "request access token success")
        
        services.requestAccessToken(username: username, password: password, success: { (token) in
            XCTAssertNotNil(token, "token is nil")
            promise.fulfill()
        }) { (error) in
            XCTFail("Error: \(error.localizedDescription)")
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    func testGetAccessTokenCouldNotDecodeJson() {
        let username = ""
        let password = ""
        UserLogin.shared.password = ""
        let promise = expectation(description: "GetAccessTokenCouldNotDecodeJson")
        
        services.requestAccessToken(username: username, password: password, success: { (token) in
            XCTFail("API should not response success without user information")
        }) { (error) in
            let jsonError = error as? JsonParseError
            XCTAssertNotNil(jsonError , "is not JSONParseError type")
            XCTAssertEqual(jsonError, JsonParseError.CouldNotDecode)
            promise.fulfill()
        }
    
        wait(for: [promise], timeout: 30)
    }

}
