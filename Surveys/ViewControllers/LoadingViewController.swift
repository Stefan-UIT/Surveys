//
//  LoadingViewController.swift
//  Surveys
//
//  Created by Trung Vo on 7/25/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    var surveysModel = SurveysModel()
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    // MARK: - Methods
    private func redirectToSurveysViewContrroller() {
        let storyboard : UIStoryboard = UIStoryboard(name: K.Main, bundle: nil)
        
        let vc :SurveysViewController = storyboard.instantiateViewController(withIdentifier: K.SurveysViewController) as! SurveysViewController
        vc.surveysModel = surveysModel
        
        let nav = UINavigationController(rootViewController: vc)
        let window = UIApplication.shared.windows[0]
        window.rootViewController = nav
    }
    
    // MARK: - API
    private func fetchSurveys() {
        surveysModel.fetchSurveys(success: {
            self.removeSpinner()
            self.redirectToSurveysViewContrroller()
        }) { (error) in
            self.removeSpinner()
            self.showAlert(message: Messages.CouldNotGetAccessToken)
        }
    }
    
    private func loadData() {
        self.showSpinner(onView: self.view)
        UserLogin.shared.requestAccessToken(success: {
            self.fetchSurveys()
        }) { (error) in
            self.removeSpinner()
            self.showAlert(message: Messages.CouldNotGetAccessToken)
        }
    }
}
