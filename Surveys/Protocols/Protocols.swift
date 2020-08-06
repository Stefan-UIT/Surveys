//
//  Protocols.swift
//  Surveys
//
//  Created by Trung Vo on 7/28/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation

protocol APIServicesProvider {
    func requestAccessToken(username: String,
                            password: String,
                            success: @escaping (_ token: Token) -> Void,
                            failure:@escaping (_ error: Error) -> Void)
    
    func fetchSurveys(page: Int,
                      success: @escaping ([Survey]) -> Void,
                      failure: @escaping (_ error: Error) -> Void)
}
