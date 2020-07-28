//
//  UIBarButtonItemTests.swift
//  SurveysTests
//
//  Created by Trung Vo on 7/28/20.
//  Copyright © 2020 Trung Vo. All rights reserved.
//

import XCTest

@testable import Surveys



class UIBarButtonItemTests: XCTestCase {
    var barButton:UIBarButtonItem!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }
    
    func testWrongImageName() {
       barButton = UIBarButtonItem.barButton(imageName: "AnInvalidName", selector: nil, actionController: nil)
       XCTAssertNil(barButton)
   }
    
    func testBarButtonSetImageSuccess() {
        barButton = UIBarButtonItem.barButton(imageName: Images.RefreshIcon, selector: nil, actionController: nil)
        
        guard let customButton = barButton.customView as? UIButton else {
            XCTFail("Error")
            return
        }
        
        let expectedImage = UIImage(named: Images.RefreshIcon)
        let buttonImage = customButton.image(for: .normal)
        XCTAssertEqual(buttonImage, expectedImage)
    }
    
    
    override func tearDownWithError() throws {
        barButton = nil
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
