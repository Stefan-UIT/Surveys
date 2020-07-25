//
//  Constant.swift
//  Surveys
//
//  Created by Trung Vo on 7/25/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation

struct Paths {
    static let GetAccessToken = "https://nimble-survey-api.herokuapp.com/oauth/token"
    static let GetSurveys = "https://nimble-survey-api.herokuapp.com/surveys.json"
}

struct K {
    static let Password = "password"
    static let Username = "username"
    static let GrantType = "grant_type"
    static let ContentType = "Content-Type"
    static let ApplicationJson = "application/json"
    static let Accept = "Accept"
    static let Authorization = "Authorization"
    static let SurveysViewController = "SurveysViewController"
    static let Main = "Main"
}

struct Messages {
    static let CouldNotGetAccessToken = "Could not get access token"
    static let CouldNotGetSurveysData = "Could not get survey data"
}

struct Constants {
    struct Images {
        static let RefreshIcon = "refresh_icon"
        static let MenuIcon = "menu_icon"
        static let ActivedDot = "actived_dot"
        static let UnactivedDot = "unactived_dot"
    }
}
