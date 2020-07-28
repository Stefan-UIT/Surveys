//
//  UserLogin.swift
//  Surveys
//
//  Created by Trung Vo on 7/25/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation


final class UserLogin:BaseViewModel {
    static let shared = UserLogin()
    
    var username:String = "carlos@nimbl3.com"
    var password:String = "antikera"
    var token:String = ""
    
    func requestAccessToken(success: @escaping ()->(), failure:@escaping (_ error:Error)->()) {
        apiServicesProvider.requestAccessToken(username: username, password: password, success: { (token) in
            self.token = token.accessToken
            success()
        }) { (error) in
            failure(error)
        }
    }
}
