//
//  UserServiceTests.swift
//  SurveysTests
//
//  Created by Trung Vo on 8/7/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import XCTest

@testable import Surveys
@testable import Moya

class UserServiceTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRequestAccessTokenSuccess() {
        let customEndpointClosure = { (target: UserService) -> Endpoint in
            return Endpoint(url: URL(target: target).absoluteString,
                            sampleResponseClosure: { .networkResponse(200 ,target.sampleData) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }
        let stubbingProvider = MoyaProvider<UserService>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        
        stubbingProvider.request(.requestToken(username: "ValidUserName", password: "ValidPassword")) { (response) in
            switch response {
            case .failure(_):
                XCTFail("Error")
            case .success(let response):
                let expectedData = UserService.requestToken(username: "ValidUserName", password: "ValidPassword3").sampleData
                XCTAssertEqual(response.data, expectedData)
            }
        }
    }
    
    func testRequestAccessTokenFailed() {
        let expectedError = NSError(domain: "domain", code: 404, userInfo: nil)
        
        let customEndpointClosure = { (target: UserService) -> Endpoint in
            return Endpoint(url: URL(target: target).absoluteString,
                            sampleResponseClosure: { .networkError(expectedError) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }
        let stubbingProvider = MoyaProvider<UserService>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        
        stubbingProvider.request(.requestToken(username: "InvalidUserName", password: "InvalidPassword")) { (response) in
            switch response {
            case .failure(let error):
                guard let nsError = error.underlyingError as NSError? else {
                    XCTFail("Wrong Error")
                    return
                }
                XCTAssertEqual(nsError.code, expectedError.code)
            case .success(_):
                XCTFail("the request should be failed")
            }
        }
    }
}
