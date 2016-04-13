//
//  MinistryTeamSignUpVC.swift
//  CruApp
//
//  Created by Daniel Lee on 2/29/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class MinistryTeamSignUpVC: UIViewController {
    
    var ministryTeam: MinistryTeamData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(ministryTeam != nil) {
           print(ministryTeam!.leaders)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let teamSuccessVC = segue.destinationViewController as!  MinistryTeamSuccessVC
        teamSuccessVC.ministryTeam = self.ministryTeam
        
        UserProfile.addMinistryTeam(self.ministryTeam!)
    }

}
