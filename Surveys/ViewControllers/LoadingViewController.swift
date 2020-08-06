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
    var surveysModel = SurveysViewModel()
    
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
        ControllerHelper.setToRootViewController(nav)
    }
    
    // MARK: - API
    private func fetchSurveys() {
        surveysModel.fetchSurveys(success: {
            self.handleFetchingSurveySuccess()
        }, failure: { (_) in
            self.handleFetchingSurveyFailed()
        })
    }
    
    private func loadData() {
        self.showSpinner(onView: self.view)
        UserLogin.shared.requestAccessToken(success: {
            self.fetchSurveys()
        }, failure: { (_) in
            self.handleFetchingTokenFailed()
        })
    }
    
    private func handleFetchingSurveySuccess() {
        removeSpinner()
        redirectToSurveysViewContrroller()
    }
    
    private func handleFetchingSurveyFailed() {
        removeSpinner()
        showAlert(message: Messages.CouldNotGetSurveysData)
    }
    
    private func handleFetchingTokenFailed() {
        removeSpinner()
        showAlert(message: Messages.CouldNotGetAccessToken)
    }
}
