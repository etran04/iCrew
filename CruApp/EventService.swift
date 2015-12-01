//
//  EventService.swift
//  CruApp
//
//  Created by Tammy Kong on 11/30/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import Foundation

class EventService {
//    var settings:Settings!
//    
//    init() {
//        settings = Settings()
//    }
    
    func loadEvents(events: (NSDictionary) -> ()) {
        displayEvents(getEventData(events))
    }
    
    func displayEvents(completionHandler : (NSData?, NSURLResponse?, NSError?) -> Void) {
        request("http://localhost:3000/api/event/list", method: "GET", completionHandler: completionHandler)
        
    }
    
    func request(url:String, method:String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        
        let reqURL = NSURL(string: url)
        let request = NSMutableURLRequest(URL: reqURL!)
        request.HTTPMethod = method
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: completionHandler)
        
        task.resume()
        
        return task
    }
    
    
    
    func getEventData(events: (NSDictionary) -> ()) -> (NSData?, NSURLResponse?, NSError?)-> () {
        return {(data : NSData?, response : NSURLResponse?, error : NSError?) in
            
            do {
                if(data == nil) {
                    print("ERROR: Cannot obtain data")
                } else {
                    let jsonList = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                    dispatch_async(dispatch_get_main_queue(), {
                        for element in jsonList {
                            if let dict = element as? [String: AnyObject] {
                                //print(dict["name"] as! String)
                                events(dict)
                            }
                        }
                    })
                }
            } catch {
                print("ERROR: HTTP request");
            }
            
        }
    }
}