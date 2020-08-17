//
//  Router.swift
//  Surveys
//
//  Created by Trung Vo on 8/17/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import UIKit

struct AppRouter {
    private var router: RouterTarget
    private var navControl: Navigatale
    
    init(target: RouterTarget, navigation: Navigatale? = nil) {
        router = target
        guard let navigation = navigation else {
            let topNav = UINavigationController()
            navControl = topNav
            return
        }
        
        navControl = navigation
    }
    
    func push() {
        guard let controller = router.controller else { return }
        navControl.pushTo(viewController: controller, animated: true)
    }
}

enum RouterTarget {
    case surveyList(surveyModel: SurveysViewModel)
    case surveyDetail(survey: Survey)
}

extension RouterTarget: NavTargetType {
    
    var storyboardName: String {
        switch self {
        default:
            return Keys.Main
        }
    }
    
    var storyboard: UIStoryboard {
        switch self {
        default:
            return UIStoryboard(name: storyboardName, bundle: nil)
        }
    }
    
    var controllerType: UIViewController.Type {
        switch self {
        case .surveyList:
            return SurveysViewController.self
        case .surveyDetail:
            return SurveyDetailViewController.self
        }
    }
            
    var controller: UIViewController? {
        return ControllerHelper.load(controllerType, fromStoryboard: storyboardName)
    }
}

protocol Navigatale {
    func pushTo(viewController: UIViewController, animated: Bool)
//    func present()
}

extension UINavigationController: Navigatale {
    func pushTo(viewController: UIViewController, animated: Bool) {
        pushViewController(viewController, animated: animated)
    }
}

extension UIWindow: Navigatale {
    func pushTo(viewController: UIViewController, animated: Bool) {
        rootViewController = viewController
        //animated
    }
}




protocol NavTargetType {
    var storyboard:UIStoryboard { get }
    var controllerType:UIViewController.Type { get }
}
