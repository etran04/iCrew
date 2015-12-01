//
//  Event.swift
//  CruApp
//
//  Created by Tammy Kong on 11/30/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import Foundation
import UIKit

struct Event {
    var name: String
    var description: String
    //var image: String
    //var startDate: Date
    //var endDate: Date
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
        //self.image = image
    }
}
