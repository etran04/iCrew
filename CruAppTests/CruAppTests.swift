//
//  CruAppTests.swift
//  CruAppTests
//
//  Created by Mariel Sanchez on 11/5/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import XCTest
@testable import CruApp

class CruAppTests: XCTestCase {
    
    func testCheckInternet() {
        let vc = EventsViewController()
        vc.checkInternet()
        XCTAssertTrue(true)
    }
    
    func testCreateVideo() {
        let video = Video(id: "111", title: "test", summary: "this is a test video")
        XCTAssertNotNil(video)
    }
    
    func testAddCampus() {
        let campus = CampusData(name: "SLO HIGH", id: "1234")
        var count = UserProfile.getCampuses().count
        
        UserProfile.addCampus(campus)
        count = UserProfile.getCampuses().count - count
        
        XCTAssertTrue(count == 1)
    }
    
    func testCreateLocation() {
        let location = Location(postcode: "93405", state: "California", suburb: "San Luis Obispo", street1: "1262 Murray Avenue", country: "USA")
        XCTAssertNotNil(location)
        
    }
}
