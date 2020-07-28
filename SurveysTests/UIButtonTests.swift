//
//  UIButtonTests.swift
//  SurveysTests
//
//  Created by Trung Vo on 7/28/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import XCTest

class ViewControllerMock : UIViewController {
    var isTapped:Bool = false
    
    @objc func onButtonTap() {
        isTapped = true
    }
}

@testable import Surveys

class UIButtonTests: XCTestCase {
    var button:UIButton!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }
    

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        button = nil
        super.tearDown()
    }
    
    func testWrongImageName() {
        button = UIButton.button(imageName: "AnInvalidName", selector: nil, actionController: nil)
        XCTAssertNil(button)
    }
    
    func testbuttonSetImageSuccess() {
        button = UIButton.button(imageName: Images.RefreshIcon, selector: nil, actionController: nil)
        
        let expectedImage = UIImage(named: Images.RefreshIcon)
        let buttonImage = button.image(for: .normal)
        XCTAssertEqual(buttonImage, expectedImage)
    }
    
    func testSetSelectorSuccess() {
        let viewController = ViewControllerMock()
        button = UIButton.button(imageName: Images.RefreshIcon, selector: #selector(viewController.onButtonTap), actionController: viewController)
        button.sendActions(for: .touchUpInside)
        
        XCTAssertTrue(viewController.isTapped)
    }
    
    func testSetSelectorFailedWithNoTarget() {
        let viewController = ViewControllerMock()
        button = UIButton.button(imageName: Images.RefreshIcon, selector: #selector(viewController.onButtonTap), actionController: nil)
        button.sendActions(for: .touchUpInside)
        
        XCTAssertFalse(viewController.isTapped)
    }
    
    func testSetSelectorFailedWithNoSelector() {
        let viewController = ViewControllerMock()
        button = UIButton.button(imageName: Images.RefreshIcon, selector: nil, actionController: viewController)
        button.sendActions(for: .touchUpInside)
        
        XCTAssertFalse(viewController.isTapped)
    }


}
