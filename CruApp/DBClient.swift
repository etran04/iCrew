//
//  EventService.swift
//  CruApp
//
//  Created by Tammy Kong on 11/30/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import Foundation

class DBClient {
    
    static func getData(action: String, dict: (NSArray) -> ()) {
        requestData(action, completionHandler: obtainData(dict))
    }
    
    static func requestData(action: String, completionHandler : (NSData?, NSURLResponse?, NSError?) -> Void) {
        //let url = "http://localhost:3001/api/" + action + "/list"
        let url = "http://pcp070211pcs.wireless.calpoly.edu:3001/api/" + action
        
        //for sorting
        //let url = http://localhost:3000/api/minstry/find?order={name: 1}
        sendGetRequest(url, completionHandler: completionHandler)
    }
    
    //request --> sendGetRequest
    static func sendGetRequest(url:String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        
        let reqURL = NSURL(string: url)
        let request = NSMutableURLRequest(URL: reqURL!)
        request.HTTPMethod = "GET"
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: completionHandler)
        
        task.resume()
        
        return task
    }
    
//    func postData(action: String, body: String, dict: (NSDictionary) -> ()) {
//        let url = "http://pcp070548pcs.wireless.calpoly.edu:3000/api/" + action + "/find"
//        //let url = "https://gcm-http.googleapis.com/gcm/send"
//        //let bdy = "order={startDate:1}"
//        //let params = ["notification":["title":"Portugal vs. Denmark", "message":"great match!"]]
//        let params = ["order":"{startDate:1}"]
//        do {
//            let bdy = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
//                sendPostRequest(url, body : bdy, completionHandler : obtainData(dict))
//        } catch {
//            print("ERRRROR")
//        }
//    
//    }
    
    //add data for Driver
    //func addData(action: String, direction : String, seats : Int, driverNumber : Int, event : String, driverName : String) {
    static func addData(action : String, body: NSData) {

        let url = "http://pcp070211pcs.wireless.calpoly.edu:3001/api/" + action
        //let url = "http://localhost:3001/api/" + action

        sendPostRequest(url, body: body, completionHandler: emptyHandler)
    }
    
    static func emptyHandler(data : NSData?, response : NSURLResponse?, error : NSError?) {
        
    }
    
//    static func deleteData(action: String, body: NSData) {
    static func deleteData(action: String) {
        let url = "http://pcp070211pcs.wireless.calpoly.edu:3001/api/" + action
        //let url = "http://localhost:3001/api/" + action
    
        sendDeleteRequest(url, completionHandler: emptyHandler)
    }
    
    //HTTP DELETE request
    static func sendDeleteRequest(url : String, completionHandler : (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        let reqURL = NSURL(string: url)
        let request = NSMutableURLRequest(URL: reqURL!)
        request.HTTPMethod = "DELETE"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
//        request.HTTPBody = body //.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler : completionHandler)
        task.resume()
        return task
    }
    
    //HTTP POST request
    static func sendPostRequest(url : String, body : NSData, completionHandler : (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        let reqURL = NSURL(string: url)
        let request = NSMutableURLRequest(URL: reqURL!)
        request.HTTPMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.HTTPBody = body //.dataUsingEncoding(NSUTF8StringEncoding)

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler : completionHandler)
        task.resume()
        return task
    }
    
    static func obtainData(dict: (NSArray) -> ()) -> (NSData?, NSURLResponse?, NSError?)-> () {
        return {(data : NSData?, response : NSURLResponse?, error : NSError?) in
            
            do {
                if(data == nil) {
                    print("ERROR: Cannot obtain data")
                } else {
                    let jsonList = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                    dispatch_async(dispatch_get_main_queue(), {
                        dict(jsonList)
                    })
                }
            } catch {
                print("ERROR: HTTP request");
            }
            
        }
    }
    
    static func addPassenger(rideId: String, action: String, body: NSData) {
        //let url = "http://localhost:3001/api/" + action
        let url = "http://pcp070211pcs.wireless.calpoly.edu:3001/api/passengers"
        sendPostRequest(url, body: body, completionHandler: {(data : NSData?, response : NSURLResponse?, error : NSError?) in
            do {
                if (data != nil) {
                    let JSONResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    //let JSONData = JSONResponse as! NSDictionary
                    //let post = JSONResponse["post"] as! NSDictionary
                    let passengerId = JSONResponse["_id"] as! String
                    //let url = "http://localhost:3001/api/ride/addPassenger"
                    let url = "http://pcp070211pcs.wireless.calpoly.edu:3001/api/rides/" + rideId + "/passengers"

                    let params = ["passenger_id": passengerId]
                    
                    do {
                        let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
                        self.sendPostRequest(url, body: body, completionHandler : self.emptyHandler);
                    } catch {
                        print("ERROR: Cannot add passenger to driver")
                    }
                    
                }
                else {
                    // TODO: display message for user
                    print("ERROR: Data not obtained from database")
                }
            }
            catch {
                print("ERROR: Cannot connect to database!!")
                print(error)
            }
        })
    }
    
}
