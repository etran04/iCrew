//
//  CommunityGroupData.swift
//  CruApp
//
//  Created by Daniel Lee on 3/2/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import Foundation

struct CommunityGroupData {
    var id: String
    var name: String
    var ministryId: String
    var time: String
    var leaders: [String]
    
    init(id: String, name: String, ministryId: String, time: String, leaders: [String]) {
        self.id = id
        self.name = name
        self.ministryId = ministryId
        self.time = time
        self.leaders = leaders
    }
}