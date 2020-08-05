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
}
