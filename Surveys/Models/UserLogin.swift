//
//  UserLogin.swift
//  Surveys
//
//  Created by Trung Vo on 7/25/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation

final class UserLogin {
    static let shared = UserLogin()
    
    let username:String = "carlos@nimbl3.com"
    let password:String = "antikera"
    var token:String = ""
}