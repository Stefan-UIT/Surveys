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
    var decoder:JSONDecoder
    
    private init(){
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    private func getHeader() -> HTTPHeaders {
        let token = "b1c2bf9e540f67fc2a390f2e4cfe41c69b0fd43c16f0cce0f8e50ec0ca025cf7"
        let header:HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization" : "Bearer \(token)"
        ]
        return header
    }
    
    func fetchSurveys(completionHandler: @escaping ([Survey])->()) {
        let path = "https://nimble-survey-api.herokuapp.com/surveys.json"
        let header = getHeader()
        
        AF.request(path, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: { (dataResponse) in
                    switch dataResponse.result {
                    case .success(let data):
                        let jsonData = try! JSONSerialization.data(withJSONObject: data)
                        
                        let surveys: [Survey] = try! self.decoder.decode([Survey].self, from: jsonData)
                        completionHandler(surveys)
                        print(surveys)
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
    }
    
}
