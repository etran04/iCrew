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
    
}
