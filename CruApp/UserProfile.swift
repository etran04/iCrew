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
            try coreDataManagedContext?.save()
        }
        catch {
            print("Unble to save data")
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
    
    class func initialUsage() {
        let entity = NSEntityDescription.entityForName("InitialUsage", inManagedObjectContext: coreDataManagedContext!)
        let initialObj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: coreDataManagedContext!)
        
        initialObj.setValue(false, forKey: "firstTime")
        
        saveContext()
    }
    
    class func isFirstTime() -> Bool {
        let fetchRequest = NSFetchRequest(entityName: "InitialUsage")
        
        do {
            let fetchedResult = try coreDataManagedContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            return fetchedResult?.count == 0;
        }
        catch {
            print("Unable to fetch")
        }
        
        return false;
    }
    
    class func removeCampuses() {
        let fetchRequest = NSFetchRequest(entityName: "Campus")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coreDataManagedContext?.persistentStoreCoordinator!.executeRequest(deleteRequest, withContext: coreDataManagedContext!)
        } catch let error as NSError {
            // TODO: handle the error
            print(error)
        }
    }
    
    class func removeMinistries() {
        let fetchRequest = NSFetchRequest(entityName: "Ministry")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coreDataManagedContext?.persistentStoreCoordinator!.executeRequest(deleteRequest, withContext: coreDataManagedContext!)
        } catch let error as NSError {
            // TODO: handle the error
            print(error)
        }
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
        
        dump(results)
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
}