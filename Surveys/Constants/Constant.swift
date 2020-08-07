//
//  Constant.swift
//  Surveys
//
//  Created by Trung Vo on 7/25/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import Foundation
import UIKit

struct Paths {
    static let BaseApiGateway = "https://nimble-survey-api.herokuapp.com"
    static let GetAccessToken = "/oauth/token"
    static let GetSurveys = "/surveys.json"
    static let DataPerPage = 10
}

struct Keys {
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
    static let AccessToken = "accessToken"
    static let AppKeys = "AppKeys_"
}

struct Messages {
    static let SomethingWentWrong = "Something went wrong"
    static let CouldNotGetAccessToken = "Could not get access token"
    static let CouldNotGetSurveysData = "Could not get survey data"
    static let InvalidNumberOfPages = "Invalid number of pages"
    static let InvalidCurrentPage = "Invalid current page"
    static let CurrentPageShouldLessThanNumberOfPage = "Current page should less than or equal number of pages"
    static let ActiveImageShouldNotBeNil = "Active Image Should Not Be Nil"
    static let InactiveImageShouldNotBeNil = "Inactive Image Should Not Be Nil"
    static let CouldNotSetRootViewControllerToWindow = "Could Not Set Root View Controller To Window"
    static let VPCCouldNotCreateButton = "VPC Could Not Create Button"
    static let NoDataFromResponse = "No data received from response."
    static let WrongJsonFormat = "Wrong json format"
    static let CouldNotDecode = "Could not decode the response"
    static let FailedToShowVerticalPageControl = "Failed to show vertical page control"
}

struct LogMessages {
    static let FetchDataFailedFromWithError: StaticString = "Fetch data failed from %@ with error: %@"
    static let FetchingDataFrom: StaticString = "Fetching data from %@"
    static let SuccessfullyFetchedNumberOfRecordsAtPage: StaticString = "Successfully fetched %d records at page %d"
    static let FetchTokenSuccessful: StaticString = "Successfully fetched with token: %{private}@"
    static let RefreshSurveyData: StaticString = "Refresh Surveys data."
    static let VPCHasBeenShowedWithTotalPages: StaticString = "Vertical page control has been showed with %d pages."
    static let RedirectToSurveyDetail: StaticString = "Redirect to survey detail: %@"
    static let ScrollToPage: StaticString = "Scroll to page %d"
    static let CouldNotGetTheWindow: StaticString = "Could not get the window"
    static let CouldNotInit: StaticString = "Could not init %@"
    static let CouldNotReusedCell: StaticString = "Could not reused cell identifer: %@"
    static let ViewControllerIsLoaded: StaticString = "%@ is loaded."
    static let KeyChainCouldNotSaveAccessToken: StaticString = "KeyChain could not save access token"
    static let KeyChainCouldNotGetAccessToken: StaticString = "KeyChain could not get access token"
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

struct ImageObjects {
    static let Placeholder = UIImage(named: "placeholder")
}
