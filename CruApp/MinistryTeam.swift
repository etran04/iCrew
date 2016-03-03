//
//  MinistryTeam.swift
//  CruApp
//
//  Created by Mariel Sanchez on 3/2/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import Foundation
import UIKit

struct MinistryTeam {
    var id: String
    var name: String
    var description: String
    var parentMinistry: String
    
    init(name: String, description: String, parentMinistry: String) {
        self.name = name
        self.description = description
        self.parentMinistry = parentMinistry
        self.id = ""
    }
    
    init(name: String, parentMinistry: String, id: String) {
        self.name = name
        self.description = ""
        self.parentMinistry = parentMinistry
        self.id = id
    }
}