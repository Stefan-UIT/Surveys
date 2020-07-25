//
//  APIServices.swift
//  Surveys
//
//  Created by Trung Vo on 7/24/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import Alamofire

final class APIServices {
    static let shared = APIServices()
    private var decoder:JSONDecoder
    
    private init(){
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    private func getHeader() -> HTTPHeaders {
//        let token = "b1c2bf9e540f67fc2a390f2e4cfe41c69b0fd43c16f0cce0f8e50ec0ca025cf7"
        var header:HTTPHeaders = [
            K.ContentType: K.ApplicationJson,
            K.Accept: K.ApplicationJson
        ]
        if !UserLogin.shared.token.isEmpty {
            header[K.Authorization] = "Bearer \(UserLogin.shared.token)"
        }
        
        return header
    }
    
    func fetchSurveys(success: @escaping ([Survey])->(), failure: @escaping (_ error:Error)->()) {
        let path = Paths.GetSurveys
        let header = getHeader()
        
        AF.request(path, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: { (dataResponse) in
                    switch dataResponse.result {
                    case .success(let data):
                        let jsonData = try! JSONSerialization.data(withJSONObject: data)
                        
                        let surveys: [Survey] = try! self.decoder.decode([Survey].self, from: jsonData)
                        success(surveys)
                        break
                    case .failure(let error):
                        failure(error)
                        print(error.localizedDescription)
                    }
                })
    }
    
    func getAccessToken(success: @escaping ()->(), failure:@escaping (_ error:Error)->()) {
        let path = Paths.GetAccessToken
        let header = getHeader()
        
        let username = UserLogin.shared.username
        let password = UserLogin.shared.password
        let params = [K.GrantType : K.Password,
                      K.Username : username,
                      K.Password : password]
        
        AF.request(path, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: { (dataResponse) in
                    switch dataResponse.result {
                    case .success(let data):
                        let jsonData = try! JSONSerialization.data(withJSONObject: data)
                        
                        let token: Token = try! self.decoder.decode(Token.self, from: jsonData)
                        UserLogin.shared.token = token.accessToken
                        success()
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                        failure(error)
                    }
                })
    }
    
}
