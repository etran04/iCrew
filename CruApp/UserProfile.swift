//
//  UserProfile.swift
//  CruApp
//
//  Created by Daniel Lee on 1/14/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import Foundation
import CoreData

class UserProfile {
    
    static let coreDataManagedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    class func saveContext() {
        do {
            try self.coreDataManagedContext!.save()
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    class func addCampus(campus: CampusData) {
        let entity = NSEntityDescription.entityForName("Campus", inManagedObjectContext: coreDataManagedContext!)
        let campusObj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: coreDataManagedContext!)
        
        campusObj.setValue(campus.name, forKey: "name")
        campusObj.setValue(campus.id, forKey: "id")
        
        saveContext()
    }
    
    class func addMinistry(ministry: MinistryData) {
        let entity = NSEntityDescription.entityForName("Ministry", inManagedObjectContext: coreDataManagedContext!)
        let ministryObj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: coreDataManagedContext!)
        
        ministryObj.setValue(ministry.name, forKey: "name")
        ministryObj.setValue(ministry.campusId, forKey: "campusId")
        ministryObj.setValue(ministry.id, forKey: "id")
        
        saveContext()
    }
    
    class func addMinistryTeam(ministryTeam: MinistryTeam) {
        let entity = NSEntityDescription.entityForName("MinistryTeam", inManagedObjectContext: coreDataManagedContext!)
        let ministryTeamObj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: coreDataManagedContext!)
        
        ministryTeamObj.setValue(ministryTeam.name, forKey: "name")
        ministryTeamObj.setValue(ministryTeam.parentMinistry, forKey: "ministryId")
        ministryTeamObj.setValue(ministryTeam.id, forKey: "id")
        
        saveContext()
    }
    
    class func addCommunityGroup(communityGroup: CommunityGroupData) {
        let entity = NSEntityDescription.entityForName("CommunityGroup", inManagedObjectContext: coreDataManagedContext!)
        let communityGroupObj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: coreDataManagedContext!)
        
        communityGroupObj.setValue(communityGroup.time, forKey: "time")
        communityGroupObj.setValue(communityGroup.ministryId, forKey: "ministryId")
        communityGroupObj.setValue(communityGroup.id, forKey: "id")
        communityGroupObj.setValue(communityGroup.leaders, forKey: "leaders")
        
        saveContext()
    }
    
    class func removeObjects(entityName: String) {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        do {
            let fetchedResult = try coreDataManagedContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let ministries = fetchedResult {
                for ministry in ministries {
                    coreDataManagedContext?.deleteObject(ministry)
                }
            }
        }
        catch let error as NSError {
            // TODO: handle the error
            print(error)
        }
        
        saveContext()
    }
    
    class func getCampuses() -> [CampusData] {
        let fetchRequest = NSFetchRequest(entityName: "Campus")
        var results = [CampusData]()
        
        do {
            let fetchedResult = try coreDataManagedContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let campuses = fetchedResult {
                for campus in campuses {
                    let campusObj = CampusData(name: campus.valueForKey("name") as! String,
                        id: campus.valueForKey("id") as! String)
                    results.append(campusObj)
                }
            }
            else {
                print("Unable to fetch campuses")
            }
        }
        catch {
            print("Unable to fetch")
        }
        
        return results;
    }
    
    class func getMinistries() -> [MinistryData] {
        let fetchRequest = NSFetchRequest(entityName: "Ministry")
        var results = [MinistryData]()
        
        do {
            let fetchedResult = try coreDataManagedContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let ministries = fetchedResult {
                for ministry in ministries {
                    let ministryObj = MinistryData(name: ministry.valueForKey("name") as! String,
                        id: ministry.valueForKey("id") as! String,
                        campusId: ministry.valueForKey("campusId") as! String)
                    
                    results.append(ministryObj)
                }
            }
            else {
                print("Unable to fetch ministries")
            }
        }
        catch {
            print("Unable to fetch")
        }
        
        return results;
    }
    
    class func getMinistryTeams() -> [MinistryTeam] {
        let fetchRequest = NSFetchRequest(entityName: "MinistryTeam")
        var results = [MinistryTeam]()
        
        do {
            let fetchedResult = try coreDataManagedContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let ministryTeams = fetchedResult {
                for ministryTeam in ministryTeams {
                    let ministryTeamObj = MinistryTeam(name: ministryTeam.valueForKey("name") as! String, parentMinistry: ministryTeam.valueForKey("ministryId") as! String, id: ministryTeam.valueForKey("id") as! String)
                    
                    results.append(ministryTeamObj)
                }
            }
            else {
                print("Unable to fetch ministry teams")
            }
        }
        catch {
            print("Unable to fetch")
        }
        
        return results;
    }
    
    class func getCommunityGroups() -> [CommunityGroupData] {
        let fetchRequest = NSFetchRequest(entityName: "Ministry")
        var results = [CommunityGroupData]()
        
        do {
            let fetchedResult = try coreDataManagedContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let communityGroups = fetchedResult {
                for communityGroup in communityGroups {
                    let communityGroupObj = CommunityGroupData(id: communityGroup.valueForKey("id") as! String, ministryId: communityGroup.valueForKey("ministryId"), time: communityGroup.valueForKey("time") as! NSDate, leaders: communityGroup.valueForKey("leaders") as! String)
                    
                    results.append(communityGroupObj)
                }
            }
            else {
                print("Unable to fetch community groups")
            }
        }
        catch {
            print("Unable to fetch")
        }
        
        return results;
    }
}