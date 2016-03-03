//
//  CommunityGroup+CoreDataProperties.swift
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

class CommunityGroupCoreData : NSManagedObject {

    @NSManaged var id: String?
    @NSManaged var ministryId: String?
    @NSManaged var time: NSDate?
    @NSManaged var leaders: String?

}
