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
    let translationLayer: Translatable
    
    init(networkTranslationLayer: Translatable = JsonTranslationLayer()) {
        translationLayer = networkTranslationLayer
    }
}

protocol Translatable {
    func decode<T>(_ type: T.Type, fromData data: Data) throws -> T where T: Decodable
}

struct JsonTranslationLayer: Translatable {
    func decode<T>(_ type: T.Type, fromData data: Data) throws -> T where T: Decodable {
        guard let result: T = try? decoder.decode(type, from: data) else {
            throw JsonParseError.couldNotDecode }
        
        return result
    }
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
