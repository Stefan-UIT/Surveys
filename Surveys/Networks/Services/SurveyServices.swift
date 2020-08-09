//
//  SurveyServices.swift
//  Surveys
//
//  Created by Trung Vo on 8/7/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import Moya

enum SurveyService {
    case getSurveys(page: Int, perPage: Int)
}

extension SurveyService: TargetType, AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    var path: String {
        switch self {
        case .getSurveys:
            return Paths.GetSurveys
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSurveys:
            return .get
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .getSurveys(let page, let perPage):
            return [
                Keys.PerPage: perPage,
                Keys.Page: page
            ]
        }
    }
    
    var task: Task {
        switch self {
        case .getSurveys:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    // For unit test
    var sampleData: Data {
        switch self {
        case .getSurveys:
            return "[{\"title\" : \"sample title\", \"description\" : \"sample description\"}]".utf8Encoded
        }
    }
}
