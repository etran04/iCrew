//
//  UserProfile.swift
//  CruApp
//
//  Created by Daniel Lee on 1/14/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import Foundation
import CoreData

/**
 * Static class that handles storing and pulling data into/from core data (cache).
 */
class UserProfile {
    // Handle used to grab core data model
    static let coreDataManagedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    /**
     * Attempts to save current state of core data model.
     */
    class func saveContext() {
        do {
            try self.coreDataManagedContext!.save()
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    /**
     * Caches the given campus to core data and attempts to save core data state afterwards.
     */
    class func addCampus(campus: CampusData) {
        // Finds the data model for Campus
        let entity = NSEntityDescription.entityForName("Campus", inManagedObjectContext: coreDataManagedContext!)
        // Creates a campus data object to cache into core data
        let campusObj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: coreDataManagedContext!)
        
        campusObj.setValue(campus.name, forKey: "name")
        campusObj.setValue(campus.id, forKey: "id")
        
        saveContext()
    }
    
    /**
     * Caches the given ministry to core data and attempts to save core data state afterwards.
     */
    class func addMinistry(ministry: MinistryData) {
        let entity = NSEntityDescription.entityForName("Ministry", inManagedObjectContext: coreDataManagedContext!)
        let ministryObj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: coreDataManagedContext!)
        
        ministryObj.setValue(ministry.name, forKey: "name")
        ministryObj.setValue(ministry.campusId, forKey: "campusId")
        ministryObj.setValue(ministry.id, forKey: "id")
        
        saveContext()
    }
    
    /**
     * Caches the given ministryTeam to core data and attempts to save core data state afterwards.
     */
    class func addMinistryTeam(ministryTeam: MinistryTeamData) {
        let entity = NSEntityDescription.entityForName("MinistryTeam", inManagedObjectContext: coreDataManagedContext!)
        let ministryTeamObj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: coreDataManagedContext!)
        
        ministryTeamObj.setValue(ministryTeam.name, forKey: "name")
        ministryTeamObj.setValue(ministryTeam.parentMinistry, forKey: "ministryId")
        ministryTeamObj.setValue(ministryTeam.id, forKey: "id")
        
        saveContext()
    }
    
    /**
     * Caches the given communityGroup to core data and attempts to save core data state afterwards.
     */
    class func addCommunityGroup(communityGroup: CommunityGroupData) {
        let entity = NSEntityDescription.entityForName("CommunityGroup", inManagedObjectContext: coreDataManagedContext!)
        let communityGroupObj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: coreDataManagedContext!)
        
        communityGroupObj.setValue(communityGroup.name, forKey: "name")
        communityGroupObj.setValue(communityGroup.time, forKey: "time")
        communityGroupObj.setValue(communityGroup.ministryId, forKey: "ministryId")
        communityGroupObj.setValue(communityGroup.id, forKey: "id")
        communityGroupObj.setValue(communityGroup.leaders.joinWithSeparator(";"), forKey: "leaders")
        
        saveContext()
    }
    
    /**
     * Removes all entities for a given name such as Campus, Ministry, CommunityGroup, MinistryTeam.
     */
    class func removeAllEntities(entityName: String) {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        do {
            let fetchedResult = try coreDataManagedContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let entities = fetchedResult {
                for entity in entities {
                    coreDataManagedContext?.deleteObject(entity)
                }
            }
        }
        catch let error as NSError {
            // TODO: handle the error
            print(error)
        }
        
        saveContext()
    }
    
    /**
     * Fetches all campus entities and stores them into a readable CampusData array that gets returned to
     * the caller.
     */
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
    
    /**
     * Fetches all ministry entities and stores them into a readable MinistryData array that gets returned to
     * the caller.
     */
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
    
    /**
     * Fetches all ministryTeam entities and stores them into a readable MinistryTeamData array that gets returned to
     * the caller.
     */
    class func getMinistryTeams() -> [MinistryTeamData] {
        let fetchRequest = NSFetchRequest(entityName: "MinistryTeam")
        var results = [MinistryTeamData]()
        
        do {
            let fetchedResult = try coreDataManagedContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let ministryTeams = fetchedResult {
                for ministryTeam in ministryTeams {
                    let ministryTeamObj = MinistryTeamData(
                        name: ministryTeam.valueForKey("name") as! String,
                        description: "",
                        parentMinistry: ministryTeam.valueForKey("ministryId") as! String,
                        id: ministryTeam.valueForKey("id") as! String)
                    
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
    
    /**
     * Fetches all community group entities and stores them into a readable CommmunityGroupData array that gets
     * returned to the caller.
     */
    class func getCommunityGroups() -> [CommunityGroupData] {
        let fetchRequest = NSFetchRequest(entityName: "CommunityGroup")
        var results = [CommunityGroupData]()
        
        do {
            let fetchedResult = try coreDataManagedContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let communityGroups = fetchedResult {
                for communityGroup in communityGroups {
                    let leaders = communityGroup.valueForKey("leaders") as! String
                    let leadersArr = leaders.componentsSeparatedByString(";")
                    
                    let communityGroupObj = CommunityGroupData(id: communityGroup.valueForKey("id") as! String, name: communityGroup.valueForKey("name") as! String, ministryId: communityGroup.valueForKey("ministryId") as! String, time: communityGroup.valueForKey("time") as! String, leaders: leadersArr)
                    
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
    
    /**
     * Fetches user's ministries and grabs the name of the ministry associated with the given
     * id.
     */
    class func getMinistryNameFromID(id: String) -> String {
        let ministries = getMinistries()
        
        for ministry in ministries {
            if ministry.id == id {
                return ministry.name
            }
        }
        
        return ""
    }
}