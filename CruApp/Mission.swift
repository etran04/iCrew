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
    //var cost: Int
    //var location: CLLocation
    //var image: UIImage
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }
}
