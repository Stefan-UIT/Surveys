//
//  NetworkManager+Survey.swift
//  Surveys
//
//  Created by Trung Vo on 8/9/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import Moya

extension NetworkManager {
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
