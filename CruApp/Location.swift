//
//  Location.swift
//  CruApp
//
//  Created by Tammy Kong on 12/2/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import Foundation
import UIKit

struct Location {
    var postcode: String
    var state: String
    var suburb: String
    var street1: String
    //var street2: String
    var country: String
    
    init(postcode: String, state: String, suburb: String, street1: String, country: String) {
        self.postcode = postcode
        self.state = state
        self.suburb = suburb
        self.street1 = street1
        self.country = country
    }
        
    func getLocation() -> String {
        return street1 + ", " + suburb + ", " + state + " " + postcode
    }
}