//
//  UserService.swift
//  Surveys
//
//  Created by Trung Vo on 8/7/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import Moya

enum UserService {
    case requestToken(username: String, password: String)
}

extension UserService: TargetType {
    var path: String {
        switch self {
        case .requestToken:
            return Paths.GetAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .requestToken:
            return .post
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .requestToken(let username, let password):
            return [Keys.GrantType: Keys.Password,
                    Keys.Username: username,
                    Keys.Password: password
            ]
        }
    }
    
    var task: Task {
        switch self {
        case .requestToken:
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    // For unit test
    var sampleData: Data {
        switch self {
        case .requestToken:
            return "{\"access_token\" : \"sample token\"}".utf8Encoded
        }
    }
}
