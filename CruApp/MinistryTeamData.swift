//
//  MinistryTeam.swift
//  CruApp
//
//  Created by Mariel Sanchez on 3/2/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import Foundation
import UIKit

struct MinistryTeamData {
    var id: String
    var name: String
    var description: String
    var parentMinistry: String
    var leaders: [NSDictionary]
    
    init(name: String, description: String, parentMinistry: String, id: String, leaders: [NSDictionary]) {
        self.name = name
        self.description = description
        self.parentMinistry = parentMinistry
        self.id = id
        self.leaders = leaders
    }
    
    init(name: String, description: String, parentMinistry: String, id: String) {
        self.name = name
        self.description = description
        self.parentMinistry = parentMinistry
        self.id = id
        self.leaders = []
    }
}