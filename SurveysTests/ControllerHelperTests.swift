//
//  ControllerHelper.swift
//  SurveysTests
//
//  Created by Trung Vo on 7/28/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import XCTest

@testable import Surveys

class ControllerHelperTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }
    

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoadControllerSuccess() {
        let controller = ControllerHelper.load(SurveysViewController.self, fromStoryboard: K.Main)
        XCTAssertNotNil(controller)
    }
    
    func testSetRootViewControllerSuccess() {
        guard let _window = ControllerHelper.window else {
            XCTFail(Messages.CouldNotGetTheWindow)
            return
        }
        
        let controller = UIViewController()
        ControllerHelper.setToRootViewController(controller)
        XCTAssertEqual(_window.rootViewController, controller)
    }

}
