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
    var startDate: String?
    var endDate: String?
    var location: Location?
    var url: String
    
    init(name: String, startDate:String?, endDate:String?, location:Location?, image: String?, description: String, url:String) {
        self.name = name
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.image = image
        self.url = url
    }
}
