//
//  CombinedObject.swift
//  CruApp
//
//  Created by Daniel Lee on 4/28/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import Foundation

class CombinedObject
{
    var ministryTeam: MinistryTeamData?
    var communityGroup: CommunityGroupData?
    
    init(ministryTeam: MinistryTeamData) {
        self.ministryTeam = ministryTeam
        self.communityGroup = nil
    }
    
    init(cg: CommunityGroupData) {
        self.ministryTeam = nil
        self.communityGroup = cg
    }
}