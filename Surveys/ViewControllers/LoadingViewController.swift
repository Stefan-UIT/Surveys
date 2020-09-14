//
//  LoadingViewController.swift
//  Surveys
//
//  Created by Trung Vo on 7/25/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import UIKit
import os.log

// MARK: - LoadingViewController
class LoadingViewController: BaseViewController {
    private var surveysModel = SurveysViewModel()
    private var loadingModel = LoadingViewModel()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    // MARK: - Methods
    private func redirectToSurveysViewContrroller() {
        guard let surveysController = ControllerHelper.load(SurveysViewController.self, fromStoryboard: Keys.Main) else { return }
        surveysController.surveysModel = surveysModel
        let nav = UINavigationController(rootViewController: surveysController)
//        let router = SurveyRouter(nav: ControllerHelper.window)
        
        let target = RouterTarget.surveyList(surveyModel: SurveysViewModel())
        RouterTarget.
        
        let router = AppRouter(target: target)
        router.push()

    }
    
    // MARK: - API
    private func fetchSurveys() {
        surveysModel.fetchSurveys { (error) in
            self.removeSpinner()
            if error != nil {
                self.handleFetchingSurveyFailed()
            } else {
                self.handleFetchingSurveySuccess()
            }
        }
    }
    
    private func loadData() {
        self.showSpinner(onView: self.view)
        loadingModel.requestAccessToken { (error) in
            guard error != nil else {
                self.fetchSurveys()
                return
            }
            self.handleFetchingTokenFailed()
        }
    }
    
    private func handleFetchingSurveySuccess() {
        redirectToSurveysViewContrroller()
    }
    
    private func handleFetchingSurveyFailed() {
        showAlert(message: Messages.CouldNotGetSurveysData)
    }
    
    private func handleFetchingTokenFailed() {
        removeSpinner()
        showAlert(message: Messages.CouldNotGetAccessToken)
    }
}
