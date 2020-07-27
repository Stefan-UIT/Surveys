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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        services = APIServices.shared
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_GetHeader() {
        let header = services.getHeader()
        XCTAssert(header.count > 1)
        
        let contentType = header.value(for: K.ContentType)
        let acceptType = header.value(for: K.Accept)
        XCTAssertEqual(contentType, K.ApplicationJson)
        XCTAssertEqual(acceptType, K.ApplicationJson)
    }
    
    func test_BearerTokenInHeader() {
        let tempToken = "b1c2bf9e540f67fc2a390f2e4cfe41c69b0fd43c16f0cce0f8e50ec0ca025cf7"
        UserLogin.shared.token = tempToken
        let header = services.getHeader()
        guard let bearerToken = header.value(for: K.Authorization) else {
            XCTFail()
            return
        }
        XCTAssert(bearerToken.contains("Bearer"))
    }
    
    func test_FetchSurveysData() {
        let token = UserLogin.shared.token
        XCTAssert(!token.isEmpty)
        
    }
    
    func test_GetAccessToken() {
        let oldToken = UserLogin.shared.token
        services.getAccessToken(success: {
            <#code#>
        }, failure: <#T##(Error) -> ()#>)
    }
    
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
