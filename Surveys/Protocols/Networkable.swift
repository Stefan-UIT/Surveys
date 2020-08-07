//
//  Networkable.swift
//  Surveys
//
//  Created by Trung Vo on 8/7/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import Moya

protocol Networkable {
    var provider: MoyaProvider<MultiTarget> { get }
    
    func requestAccessToken(username: String, password: String, completion: @escaping (Token?, Error?) -> Void)
    func fetchSurveys(page: Int, perPage: Int, completion: @escaping ([Survey]?, Error?) -> Void)
}
