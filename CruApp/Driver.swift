//
//  Driver.swift
//  CruApp
//
//  Created by Tammy Kong on 2/4/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import Foundation
import UIKit

class Driver {
    var rideId: String
    var name: String
    var phoneNumber: String
    var availableSeats: Int
    var eventId: String
    var departureTime: String
    var state: String
    var street: String
    var country: String
    var zipcode: String
    var city: String
    var departureLoc1: String
    var departureLoc2: String
    var passengers = [Passenger]()
    
    
    init(rideId: String, name: String, phoneNumber: String, eventId: String, departureTime: String, state: String, street: String, country: String, zipcode: String, city: String) {
        self.rideId = rideId
        self.name = name
        self.phoneNumber = phoneNumber
        self.eventId = eventId
        self.departureTime = departureTime
        self.state = state
        self.street = street
        self.country = country
        self.zipcode = zipcode
        self.city = city
        self.departureLoc1 = ""
        self.departureLoc2 = ""
        self.passengers = []
        self.availableSeats = 0
    }
    
    init(rideId:String, eventId:String, departureTime:String, departureLoc1: String, departureLoc2:String, availableSeats:Int, passengers:[Passenger]) {
        self.rideId = rideId
        self.eventId = eventId
        self.departureTime = departureTime
        self.departureLoc1 = departureLoc1
        self.departureLoc2 = departureLoc2
        self.availableSeats = availableSeats
        self.passengers += passengers
        self.state = ""
        self.street = ""
        self.country = ""
        self.zipcode = ""
        self.city = ""
        self.name = ""
        self.phoneNumber = ""
    }

}