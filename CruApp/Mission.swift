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
    var image: String?
    var cost: Int
    var location: Location?
    var startDate: String?
    var endDate: String?
    var url: String
    var leaders: String
    var displayingImage: UIImage?
    
    init(name: String, description: String, image: String, cost: Int, location: Location, startDate: String, endDate: String, url: String, leaders: String) {
        self.name = name
        self.description = description
        self.image = image
        self.cost = cost
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.url = url
        self.leaders = leaders
        self.displayingImage = nil
    }
}

    
