//
//  LoadingViewController.swift
//  Surveys
//
//  Created by Trung Vo on 7/25/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import UIKit
import os.log

// MARK: - ControllerHelper
class ControllerHelper {
    class var window:UIWindow? {
        get {
            return UIApplication.shared.windows.first
        }
    }
    
    class func load<T>(_ type: T.Type, fromStoryboard storyboardName:String) -> T? where T : UIViewController {
        let storyboard : UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        let identifier = String(describing: T.self)
        guard let controller = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            os_log(LogMessages.CouldNotInit, log: .ui, type: .error, identifier)
            return nil
        }
        return controller
    }
    
    class func setToRootViewController(_ controller:UIViewController) {
        guard let _window = window else {
            os_log(LogMessages.CouldNotGetTheWindow, log: .ui, type: .error)
            return
        }
        _window.rootViewController = controller
    }
}

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
        guard let surveysController = ControllerHelper.load(SurveysViewController.self, fromStoryboard: K.Main) else { return }
        surveysController.surveysModel = surveysModel
        let nav = UINavigationController(rootViewController: surveysController)
        ControllerHelper.setToRootViewController(nav)
    }
    
    // MARK: - API
    private func fetchSurveys() {
        surveysModel.fetchSurveys(success: {
            self.handleFetchingSurveySuccess()
        }) { (error) in
            self.handleFetchingSurveyFailed()
        }
    }
    
    private func loadData() {
        self.showSpinner(onView: self.view)
        UserLogin.shared.requestAccessToken(success: {
            self.fetchSurveys()
        }) { (error) in
            self.handleFetchingTokenFailed()
        }
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
