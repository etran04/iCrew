//
//  Driver.swift
//  CruApp
//
//  Created by Tammy Kong on 2/4/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import Foundation
import UIKit

struct Driver {
    var id: String
    var name: String
    var number: String
    var eventId: String
    var departureTime: String
    
    init(id: String, name: String, number: String, eventId: String, departureTime: String) {
        self.id = id
        self.name = name
        self.number = number
        self.eventId = eventId
        self.departureTime = departureTime
    }
}