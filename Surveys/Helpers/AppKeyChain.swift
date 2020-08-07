//
//  AppKeyChain.swift
//  Surveys
//
//  Created by Trung Vo on 8/7/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import KeychainSwift
import os.log

let appKeyChain = KeyChain.share

class KeyChain: KeychainSwift {
    static let share = KeyChain(keyPrefix: Keys.AppKeys)
    
    var accessToken: String {
        guard let token = get(Keys.AccessToken) else {
            return ""
        }
        return token
    }
    
    private override init() {
        super.init()
    }
    
    private override init(keyPrefix: String) {
        super.init(keyPrefix: keyPrefix)
    }
    
    func saveAccessToken(_ token: String) {
        guard set(token, forKey: Keys.AccessToken) else {
            os_log(LogMessages.KeyChainCouldNotSaveAccessToken, log: .system, type: .error)
            return
        }
    }
}
