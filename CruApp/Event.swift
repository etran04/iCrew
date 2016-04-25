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
    var image: String?
    var imageSq: String?
    var startDate: String?
    var endDate: String?
    var location: Location?
    var url: String
    var rideShareFlag: Bool?
    var displayingImage: UIImage?
    
    init(name: String, startDate:String?, endDate:String?, location:Location?, image: String?, imageSq: String?, description: String, url:String, rideShareFlag: Bool) {
        self.name = name
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.image = image
        self.imageSq = imageSq
        self.url = url
        self.rideShareFlag = rideShareFlag
        self.displayingImage = nil
    }
}
