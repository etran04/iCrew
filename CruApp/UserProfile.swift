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
}