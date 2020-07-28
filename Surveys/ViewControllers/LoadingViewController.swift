//
//  LoadingViewController.swift
//  Surveys
//
//  Created by Trung Vo on 7/25/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import UIKit

class ControllerHelper {
    class var window:UIWindow? {
        get {
            return UIApplication.shared.windows.first
        }
    }
    class func load<T>(_ type: T.Type, fromStoryboard storyboardName:String) -> T? where T : UIViewController {
        let storyboard : UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as? T else {
            return nil
        }
        return controller
    }
    
    class func setToRootViewController(_ controller:UIViewController) {
        guard let _window = window else {
            print(Messages.CouldNotGetTheWindow)
            return
        }
        _window.rootViewController = controller
    }
}

class LoadingViewController: UIViewController {
    var surveysModel = SurveysModel()
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
