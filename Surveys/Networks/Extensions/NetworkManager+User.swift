//
//  NetworkManager+UserService.swift
//  Surveys
//
//  Created by Trung Vo on 8/9/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import Moya

extension NetworkManager {
    func requestAccessToken(username: String, password: String, completion: @escaping (Token?, Error?) -> Void) {
        provider.request(MultiTarget(UserService.requestToken(username: username,
                                                              password: password)),
                         completion: { (response) in
                            switch response {
                            case .failure(let error):
                                completion(nil, error)
                            case .success(let response):
                                do {
                                    let token = try self.translationLayer.jsonDecode(Token.self, fromData: response.data)
                                    completion(token, nil)
                                } catch let error {
                                    completion(nil, error)
                                }
                            }
        })
    }
}
