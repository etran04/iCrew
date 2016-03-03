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
    var ministryId: String
    var time: NSDate
    var leaders: String
    
    init(id: String, ministryId: String, time: NSDate, leaders: String) {
        self.id = id
        self.ministryId = ministryId
        self.time = time
        self.leaders = leaders
    }
}