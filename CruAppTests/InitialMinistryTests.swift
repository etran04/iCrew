//
//  InitialMinistryTests.swift
//  CruApp
//
//  Created by Mariel Sanchez on 3/11/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import XCTest
@testable import CruApp

class InitialMinistryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSetMinistries() {
        let vc = InitialMinistryTableViewController()
        let dbClient = DBClient()
        dbClient.getData("ministry", dict: vc.setMinistries)
        
        XCTAssertTrue(vc.ministriesCollection.count == 2)
    }
    
}
