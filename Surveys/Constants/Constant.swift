//
//  Constant.swift
//  Surveys
//
//  Created by Trung Vo on 7/25/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation

struct Paths {
    static let BaseApiGateway = "https://nimble-survey-api.herokuapp.com"
    static let GetAccessToken = BaseApiGateway + "/oauth/token"
    static let GetSurveys = BaseApiGateway + "/surveys.json"
    static let DataPerPage = 10
}

struct K {
    static let PerPage = "per_page"
    static let Page = "page"
    static let Password = "password"
    static let Username = "username"
    static let GrantType = "grant_type"
    static let ContentType = "Content-Type"
    static let ApplicationJson = "application/json"
    static let Accept = "Accept"
    static let Authorization = "Authorization"
    static let SurveysViewController = "SurveysViewController"
    static let SurveyDetailViewController = "SurveyDetailViewController"
    static let Main = "Main"
}

struct Messages {
    static let SomethingWentWrong = "Something went wrong"
    static let CouldNotGetAccessToken = "Could not get access token"
    static let CouldNotGetSurveysData = "Could not get survey data"
    static let InvalidNumberOfPages = "Invalid number of pages"
    static let InvalidCurrentPage = "Invalid current page"
    static let CurrentPageShouldLessThanOrEqualNumberOfPage = "Current page should less than or equal number of pages"
    static let ActiveImageShouldNotBeNil = "Active Image Should Not Be Nil"
    static let InactiveImageShouldNotBeNil = "Inactive Image Should Not Be Nil"
    static let CouldNotGetTheWindow = "Could Not Get The Window"
    static let CouldNotSetRootViewControllerToWindow = "Could Not Set Root View Controller To Window"
    static let VPCCouldNotCreateButton = "VPC Could Not Create Button"
}

struct Texts {
    static let Surveys = "Surveys"
}

struct Images {
    static let RefreshIcon = "refresh_icon"
    static let MenuIcon = "menu_icon"
    static let ActivedDot = "actived_dot"
    static let InactivedDot = "unactived_dot"
}

