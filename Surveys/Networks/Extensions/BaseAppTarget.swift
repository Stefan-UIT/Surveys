//
//  AppTargetType.swift
//  Surveys
//
//  Created by Trung Vo on 8/7/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import Moya

extension TargetType {
    var baseURL: URL {
        return URL(string: Paths.BaseApiGateway)!
    }
    
    var headers: [String: String]? {
        return [ Keys.ContentType: Keys.ApplicationJson ]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
