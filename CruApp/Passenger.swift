//
//  Passenger.swift
//  CruApp
//
//  Created by Tammy Kong on 2/18/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import Foundation
import UIKit

class Passenger {
    var name: String
    var eventId: String
    var phoneNumber: String
    var direction: String
    var gcmId: String
    var passengerId: String
    var rideId: String
    var departureTime: String
    var departureLoc1: String
    var departureLoc2: String
    var driverName: String
    var driverNumber: String
    
    init(name: String, eventId: String, phoneNumber: String, direction: String, departureTime: String, gcmId: String) {
        self.name = name
        self.eventId = eventId
        self.phoneNumber = phoneNumber
        self.direction = direction
        self.departureTime = departureTime
        self.gcmId = gcmId
        self.passengerId = ""
        self.rideId = ""
        self.departureLoc1 = ""
        self.departureLoc2 = ""
        self.driverName = ""
        self.driverNumber = ""
    }
    
    init(passengerId: String, gcmId: String, phoneNumber: String, name: String) {
        self.passengerId = passengerId
        self.gcmId = gcmId
        self.phoneNumber = phoneNumber
        self.name = name
        self.eventId = ""
        self.direction = ""
        self.departureTime = ""
        self.departureTime = ""
        self.departureLoc1 = ""
        self.departureLoc2 = ""
        self.driverName = ""
        self.driverNumber = ""
        self.rideId = ""
    }
    
    init(rideId:String, passengerId:String, eventId:String, departureTime:String, departureLoc1:String, departureLoc2:String, driverNumber:String, driverName:String) {
        self.rideId = rideId
        self.passengerId = passengerId
        self.eventId = eventId
        self.departureTime = departureTime
        self.departureLoc1 = departureLoc1
        self.departureLoc2 = departureLoc2
        self.driverNumber = driverNumber
        self.driverName = driverName
        self.phoneNumber = ""
        self.name = ""
        self.gcmId = ""
        self.direction = ""
    }
}