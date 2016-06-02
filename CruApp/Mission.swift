//
//  Mission.swift
//  CruApp
//
//  Created by Tammy Kong on 12/1/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import Foundation
import UIKit

struct Mission {
    var name: String
    var description: String
    var cost: Int
    var location: Location?
    var startDate: String?
    var endDate: String?
    var url: String
    var leaders: String
    var displayingImage: UIImage?
    var displayingGroupImage: UIImage?
    var imageUrl: String
    
    init(name: String, description: String, cost: Int, location: Location, startDate: String, endDate: String, url: String, leaders: String) {
        self.name = name
        self.description = description
        self.cost = cost
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.url = url
        self.leaders = leaders
        self.displayingImage = nil
        self.displayingGroupImage = nil
        self.imageUrl = ""
    }
}

    
