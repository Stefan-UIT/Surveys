//
//  NetworkManager.swift
//  Surveys
//
//  Created by Trung Vo on 8/7/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import Moya
import os.log

enum JsonParseError: Error {
    case couldNotDecode
    
    var errorDescription: String {
        switch self {
        case .couldNotDecode:
            return Messages.CouldNotDecode
        }
        
    }
}

class NetworkManager: Networkable {
    let authPlugin = AccessTokenPlugin { (_) -> String in
        return appKeyChain.accessToken
    }
    
    lazy var provider = MoyaProvider<MultiTarget>(plugins: [authPlugin])
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    private func jsonDecode<T>(_ type: T.Type,
                               fromData data: Data) throws -> T where T: Decodable {
        guard let result: T = try? decoder.decode(type, from: data) else {
            throw JsonParseError.couldNotDecode }
        
        return result
    }
    
    func requestAccessToken(username: String, password: String, completion: @escaping (Token?, Error?) -> Void) {
        provider.request(MultiTarget(UserService.requestToken(username: username,
                                                              password: password)),
                         completion: { (response) in
                            switch response {
                            case .failure(let error):
                                completion(nil, error)
                            case .success(let response):
                                do {
                                    let token = try self.jsonDecode(Token.self, fromData: response.data)
                                    completion(token, nil)
                                } catch let error {
                                    completion(nil, error)
                                }
                            }
        })
    }
    
    func fetchSurveys(page: Int,
                      perPage: Int = Paths.DataPerPage,
                      completion: @escaping ([Survey]?, Error?) -> Void) {
        provider.request(MultiTarget(SurveyService.getSurveys(page: page, perPage: perPage)),
                         completion: { (response) in
                            switch response {
                            case .failure(let error):
                                completion(nil, error)
                            case .success(let response):
                                do {
                                    let surveys = try self.jsonDecode([Survey].self, fromData: response.data)
                                    completion(surveys, nil)
                                } catch let error {
                                    completion(nil, error)
                                }
                            }
        })
    }
}
