//
//  SurveysModel.swift
//  Surveys
//
//  Created by Trung Vo on 7/26/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation

class SurveysModel {
    private var surveys = [Survey]()
    
    var count:Int {
        return surveys.count
    }
    
    func survey(at position: Int) -> Survey {
        return surveys[position]
    }
    
    func fetchSurveys(success: @escaping ()->(), failure: @escaping (_ error:Error)->()) {
        APIServices.shared.fetchSurveys(success: { (data) in
            self.surveys = data
            success()
        }) { (error) in
            failure(error)
        }
    }
    
}
