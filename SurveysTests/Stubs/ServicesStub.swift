//
//  ServicesStubs.swift
//  SurveysTests
//
//  Created by Trung Vo on 7/28/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation

@testable import Surveys

struct DummyData {
    static let survey1:Survey = Survey(title: "survey1", description: "description1", coverImageUrl: "url1")
    static let survey2:Survey = Survey(title: "survey2", description: "description2", coverImageUrl: "url2")
    static let username = "username"
    static let password = "password"
    
    struct Response {
        static let error = NSError(domain: "test", code: 999)
        static let token = Token(accessToken: "123")
    }
    
    struct Location {
        static let streetAddres = "269–299 Geary St"
        static let city = "San Francisco"
        static let subLocality = "Union Square"
        static let state = "CA"
        static let postalCode = "94102"
        static let country = "Estados Unidos"
        static let isoCountry = "US"
        
        static var fullAddress: String {
            return "\(city), \(postalCode)"
        }
    }
    
    struct Api {
        static let response = ["title": "iOS Developer Test"]
        
        static var responseArray: [[String: Any]] {
            return [response]
        }
    }
    
}

class ServicesStub: APIServicesProvider {
    var surveys:[Survey] = [DummyData.survey1, DummyData.survey2]
    var isValidAccessToken:Bool = true
    
    func requestAccessToken(username:String, password:String, success: @escaping (_ token:Token)->(), failure:@escaping (_ error:Error)->()) {
        let isUsernameCorrect = username == DummyData.username
        let isPasswordCorrect = password == DummyData.password
        if isUsernameCorrect && isPasswordCorrect {
            success(DummyData.Response.token)
        } else {
            failure(DummyData.Response.error)
        }
    }
    func fetchSurveys(success: @escaping ([Survey])->(), failure: @escaping (_ error:Error)->()) {
        if self.isValidAccessToken {
            success(surveys)
        } else {
            failure(DummyData.Response.error)
        }
    }
    
}
