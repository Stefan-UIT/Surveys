//
//  LoadingViewModel.swift
//  Surveys
//
//  Created by Trung Vo on 8/7/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import UIKit

final class LoadingViewModel: BaseViewModel {
    func requestAccessToken(completion: @escaping (_ error: Error?) -> Void) {
        let user = UserLogin()
        provider.requestAccessToken(username: user.username,
                                    password: user.password) { (token, error) in
                                        guard let token = token else {
                                            completion(error!)
                                            return
                                        }
                                        appKeyChain.saveAccessToken(token.accessToken)
                                        completion(nil)
        }
    }
}
