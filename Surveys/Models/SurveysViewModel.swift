//
//  SurveysViewModel.swift
//  Surveys
//
//  Created by Trung Vo on 7/26/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import os.log

class BaseViewModel {
    let apiServicesProvider: APIServicesProvider!
    
    init(provider:APIServicesProvider = APIServices.shared) {
        apiServicesProvider = provider
    }
}

final class SurveysViewModel:BaseViewModel {
    private var surveys = [Survey]()
    private var currentPage = 1
    private var isLastPageReached:Bool = false
    private var isFetchInProgress = false
    
    var count:Int {
        return surveys.count
    }
    
    func survey(at position: Int) -> Survey {
        return surveys[position]
    }
    
    func resetData() {
        surveys.removeAll()
        currentPage = 1
        isLastPageReached = false
        isFetchInProgress = false
    }
    
    func shouldLoadMoreItems(currentRow:Int) -> Bool {
        let isLastRow =  (currentRow == count - 1)
        return isLastRow && !isLastPageReached
    }
    
    func fetchSurveys(success: @escaping ()->(), failure: @escaping (_ error:Error)->()) {
        guard !isFetchInProgress else { return }
        
        isFetchInProgress = true
        apiServicesProvider.fetchSurveys(page:currentPage, success: { (data) in
            self.isFetchInProgress = false
            self.calculateCurrentPageAndIsLastPageReached(numberOfNewData: data.count)
            self.surveys.append(contentsOf: data)
            success()
        }) { (error) in
            self.isFetchInProgress = false
            failure(error)
        }
    }
    
    private func calculateCurrentPageAndIsLastPageReached(numberOfNewData:Int) {
        isLastPageReached = numberOfNewData < Paths.DataPerPage
        if !isLastPageReached {
            currentPage += 1
        }
    }
}
