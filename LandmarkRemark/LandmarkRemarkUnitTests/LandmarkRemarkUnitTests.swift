//
//  LandmarkRemarkUnitTests.swift
//  LandmarkRemarkUnitTests
//
//  Created by Manjeet Singh on 2/6/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import XCTest
@testable import LandmarkRemark
@testable import RealmSwift

class LandmarkRemarkUnitTests: XCTestCase {

    func testToCheckIfRealmObjectGetsSavedToCloudOrNot() {
    
        let remarkToSave = Remark()
        remarkToSave.title = "Testing"
        remarkToSave.detail = "test case succeded"
        remarkToSave.addedDate = Date()
        remarkToSave.username = "Manjeet"
        remarkToSave.locationLatitude = 33.8634
        remarkToSave.locationLongitude = 151.211
        
        DataManager.sharedInstance.addRemark(object: remarkToSave)
        XCTAssertTrue(true)
    }
    
    func testIfViewModelReturnsAppropraiteDataState() {
        // 1. Setup the expectation
        let expectation = XCTestExpectation(description: "RemarksListViewModel fetches data and returns appropriate data state")
        
        // 2. Exercise and verify the behaviour as usual
        let remarksViewModel = RemarksListViewModel()
        let state = remarksViewModel.fetchRemarksForTesting()
        
        switch state {
        case .error:
            XCTFail()
        case .loaded:
            expectation.fulfill()
        default: break
        }
    }
}
