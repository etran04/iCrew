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
    
    class func addCampus(campusName: String) {
        let entity = NSEntityDescription.entityForName("Campus", inManagedObjectContext: coreDataManagedContext!)
        let campus = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: coreDataManagedContext!)
        
        campus.setValue(campusName, forKey: "name")
        
        saveContext()
    }
    
    class func addMinistry(ministryName: String, campusName: String) {
        let entity = NSEntityDescription.entityForName("Ministry", inManagedObjectContext: coreDataManagedContext!)
        let ministry = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: coreDataManagedContext!)
        
        ministry.setValue(ministryName, forKey: "name")
        ministry.setValue(campusName, forKey: "campusName")
        
        saveContext()
    }
    
    class func getCampuses() -> [String] {
        let fetchRequest = NSFetchRequest(entityName: "Campus")
        var results = [String]()
        
        do {
            let fetchedResult = try coreDataManagedContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let campuses = fetchedResult {
                for campus in campuses {
                    results.append(campus.valueForKey("name") as! String)
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
    
    class func getMinistries() -> [String] {
        let fetchRequest = NSFetchRequest(entityName: "Ministry")
        var results = [String]()
        
        do {
            let fetchedResult = try coreDataManagedContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let ministries = fetchedResult {
                for ministry in ministries {
                    results.append(ministry.valueForKey("name") as! String)
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