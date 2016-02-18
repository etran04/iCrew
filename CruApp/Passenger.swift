//
//  Passenger.swift
//  CruApp
//
//  Created by Tammy Kong on 2/18/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import Foundation
import UIKit

struct Passenger {
    var name: String
    var eventId: String
    var phoneNumber: String
    var direction: String
    var gcmId: Int
    
    
    init(name: String, eventId: String, phoneNumber: String, direction: String, gcmId: Int) {
        self.name = name
        self.eventId = eventId
        self.phoneNumber = phoneNumber
        self.direction = direction
        self.gcmId = gcmId
        
    }
}