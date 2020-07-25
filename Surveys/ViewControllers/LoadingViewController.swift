//
//  LoadingViewController.swift
//  Surveys
//
//  Created by Trung Vo on 7/25/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    // MARK: - API
    private func fetchSurveys() {
        APIServices.shared.fetchSurveys(success: { (surveys) in
            self.removeSpinner()
            self.redirectToSurveysViewContrroller(surveys: surveys)
        }) { (error) in
            self.removeSpinner()
            self.showAlert(message: Messages.CouldNotGetAccessToken)
        }
    }
    
    private func redirectToSurveysViewContrroller(surveys:[Survey]) {
        let storyboard : UIStoryboard = UIStoryboard(name: K.Main, bundle: nil)
        let vc :SurveysViewController = storyboard.instantiateViewController(withIdentifier: K.SurveysViewController) as! SurveysViewController
        vc.surveys = surveys
        
        let nav = UINavigationController(rootViewController: vc)
        let window = UIApplication.shared.windows[0]
        window.rootViewController = nav
    }
    
    private func loadData() {
        self.showSpinner(onView: self.view)
        APIServices.shared.getAccessToken(success: {
            self.fetchSurveys()
        }) { (error) in
            self.removeSpinner()
            self.showAlert(message: Messages.CouldNotGetAccessToken)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
