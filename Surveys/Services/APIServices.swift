//
//  APIServices.swift
//  Surveys
//
//  Created by Trung Vo on 7/24/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import Alamofire

enum JsonParseError: Error {
    case NullData
    case WrongJsonFormat
    case CouldNotDecode
}

final class APIServices: APIServicesProvider {
    static let shared = APIServices()
    private var decoder:JSONDecoder
    
    private init(){
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    private var bearerToken: String {
        get {
            return "Bearer \(UserLogin.shared.token)"
        }
    }
    
    func getHeader() -> HTTPHeaders {
        var header:HTTPHeaders = [
            K.ContentType: K.ApplicationJson,
            K.Accept: K.ApplicationJson
        ]
        if !UserLogin.shared.token.isEmpty {
            header[K.Authorization] = bearerToken
        }
        
        return header
    }
    
    private func jsonDecode<T>(_ type: T.Type, fromAnyObject data:Any) throws -> T where T : Decodable {
        guard !(data is NSNull) else { throw JsonParseError.NullData }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data) else { throw JsonParseError.WrongJsonFormat }
        guard let result:T = try? decoder.decode(type, from: jsonData) else { throw JsonParseError.CouldNotDecode }
        
        return result
    }
    
    
    func fetchSurveys(page:Int,
                      success: @escaping ([Survey])->(),
                      failure: @escaping (_ error:Error)->()) {
        let path = Paths.GetSurveys
        let params:[String:Any] = [
            K.PerPage  : Paths.DataPerPage,
            K.Page      : page
        ]
        
        request(path: path, method: .get, parameters: params, success: { (data) in
            do {
                let surveys = try self.jsonDecode([Survey].self, fromAnyObject: data)
                success(surveys)
            } catch let error {
                failure(error)
            }
            
        }) { (error) in
            failure(error)
        }
    }
    
    func requestAccessToken(username:String, password:String, success: @escaping (_ token:Token)->(), failure:@escaping (_ error:Error)->()) {
        let path = Paths.GetAccessToken

        let params = [K.GrantType : K.Password,
                      K.Username : username,
                      K.Password : password]
        
        request(path: path, method: .post, parameters: params , success: { (data) in
            do {
                let token = try self.jsonDecode(Token.self, fromAnyObject: data)
                success(token)
            } catch let error {
                failure(error)
            }
        }) { (error) in
            failure(error)
        }
    }
    
    private func request(path:String, method:HTTPMethod, parameters: Parameters? = nil, success: @escaping (_ data:Any)->(), failure: @escaping (_ error:Error)->()) {
        let header = getHeader()
        let encoding:ParameterEncoding =  (method == .get) ? URLEncoding.default : JSONEncoding.default
        AF.request(path, method: method, parameters: parameters, encoding: encoding, headers: header).responseJSON(completionHandler: { (dataResponse) in
               switch dataResponse.result {
               case .success(let data):
                   success(data)
                   break
               case .failure(let error):
                   failure(error)
            }
        })
    }
}
