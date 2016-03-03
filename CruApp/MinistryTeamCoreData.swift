//
//  MinistryTeam+CoreDataProperties.swift
//  CruApp
//
//  Created by Daniel Lee on 3/2/16.
//  Copyright © 2016 iCrew. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

class MinistryTeamCoreData : NSManagedObject {

    @NSManaged var id: String?
    @NSManaged var ministryId: String?
    @NSManaged var name: String?

}
