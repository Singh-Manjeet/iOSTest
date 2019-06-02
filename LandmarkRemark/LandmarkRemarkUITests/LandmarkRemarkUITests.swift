//
//  LandmarkRemarkUITests.swift
//  LandmarkRemarkUITests
//
//  Created by Manjeet Singh on 3/6/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import XCTest
@testable import LandmarkRemark
@testable import RealmSwift

extension XCUIElement {
    // The following is a workaround for inputting text in the
    //simulator when the keyboard is hidden
    func setText(text: String, application: XCUIApplication) {
        UIPasteboard.general.string = text
        doubleTap()
        application.menuItems["Paste"].tap()
    }
}

class LandmarkRemarkUITests: XCTestCase {

    let app = XCUIApplication()
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testLoginUI() {

        let enterUsernameTextField =  app.otherElements.textFields["Username"]
        enterUsernameTextField.setText(text: "Manjeet", application: app)
        
        let loginButton =  app.otherElements.buttons["LoginButton"]
        loginButton.tap()
    }

}
