//
//  MinistryData.swift
//  CruApp
//
//  Created by Daniel Lee on 2/17/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import Foundation

struct MinistryData {
    var name: String
    var id: String
    var campusId: String
    
    init(name: String, id: String, campusId: String) {
        self.name = name;
        self.id = id;
        self.campusId = campusId;
    }
}