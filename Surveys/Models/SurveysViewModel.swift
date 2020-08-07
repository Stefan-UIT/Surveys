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
    var provider: Networkable!
    
    init(provider: Networkable = NetworkManager()) {
        self.provider = provider
    }
}

final class SurveysViewModel: BaseViewModel {
    private var surveys = [Survey]()
    private var currentPage = 1
    private var isLastPageReached: Bool = false
    private var isFetchInProgress = false
    
    var count: Int {
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
    
    func shouldLoadMoreItems(currentRow: Int) -> Bool {
        let isLastRow =  (currentRow == count - 1)
        return isLastRow && !isLastPageReached
    }
    
    func fetchSurveys(completion: @escaping (_ error: Error?) -> Void) {
        guard !isFetchInProgress else { return }
        
        isFetchInProgress = true
        provider.fetchSurveys(page: currentPage,
                              perPage: Paths.DataPerPage,
                              completion: { (responseData, error) in
                                guard let responseData = responseData else {
                                    self.isFetchInProgress = false
                                    completion(error!)
                                    return
                                }
                                self.isFetchInProgress = false
                                self.calculateCurrentPageAndIsLastPageReached(numberOfNewData: responseData.count)
                                self.surveys.append(contentsOf: responseData)
                                completion(nil)
        })
    }
    
    private func calculateCurrentPageAndIsLastPageReached(numberOfNewData: Int) {
        isLastPageReached = numberOfNewData < Paths.DataPerPage
        if !isLastPageReached {
            currentPage += 1
        }
    }
}
