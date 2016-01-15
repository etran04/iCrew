//
//  UserProfile.swift
//  CruApp
//
//  Created by Daniel Lee on 1/14/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import Foundation

class UserProfile {
    
    var campuses = [Campus]()
    var ministries = [Ministry]()
    
    let coreDataManagedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func addCampus(campusName: String) {
        
    }
}