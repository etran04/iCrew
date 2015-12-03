//
//  EventsViewController.swift
//  CruApp
//
//  Created by Tammy Kong on 11/30/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import UIKit
import EventKit

class EventsViewController: UITableViewController {

    //var events:[Event] = eventsData
    
    var eventsCollection = [Event]()
    
    //    var service:EventService!
    //    var settings:Settings!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //        service = PostService()
        //        service.getEvents {
        //            (response) in
        //            self.loadEvents(response[]! as NSArray)
        
        //        }
        //        service = EventService()
        //        service.request(settings.getEvents, method:"GET") {
        //            (response) in
        //            self.loadEvents(response)
        //        }
        
        var dbClient:DBClient!
        dbClient = DBClient()
        dbClient.getData("event", dict: setEvents)
    }
    
    
//    func insertEvent(dict : NSDictionary) {
//        self.tableView.beginUpdates()
//        events.insert(Event(dict: dict)!, atIndex: 0)
//        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
//        self.tableView.endUpdates()
//    }
//    
    func setEvents(event:NSDictionary) {
        //self.tableView.beginUpdates()
        
        let name = event["name"] as! String
        let startDate = event["startDate"] as! String!
        let endDate = event["endDate"] as! String!
        let description = event["description"] as! String
        
        let location = Location(
            postcode: event["location"]?.objectForKey("postcode") as! String,
            state: event["location"]?.objectForKey("state") as! String,
            suburb: event["location"]?.objectForKey("suburb") as! String,
            street1: event["location"]?.objectForKey("street1") as! String,
            country: event["location"]?.objectForKey("country") as! String)
        
        let image = event["image"]?.objectForKey("secure_url") as! String!
        let url = event["url"] as! String
        
        let eventObj = Event(name: name, startDate: startDate, endDate: endDate, location: location, image: image, description: description, url: url)
        
        eventsCollection.append(eventObj)
        self.tableView.reloadData()

        //self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
        //self.tableView.endUpdates()
    }
    
    //    func loadEvents(events: NSArray) {
    //        for event in events {
    //            if let dict = event as? [String: AnyObject] {
    //                let name = dict["name"] as! String
    //                let description = dict["description"] as! String
    //                let image = dict["image"] as! String
    //                let eventObj = Event(name: name, description: description, image: image)
    //                eventsCollection.append(eventObj)
    //            }
    //            dispatch_async(dispatch_get_main_queue()) {
    //                self.tableView.reloadData()
    //            }
    //        }
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsCollection.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventViewCell
            
            let event = eventsCollection[indexPath.row]
            cell.eventName.text = event.name
            //cell.eventLocation.text = "Where: " + event.location!
            cell.eventStartTime.text = "Start Time: " + "1:11"
            cell.eventDate.text = event.startDate
            //cell.calendarButton //JORDAN ADD SOMETHING HERE TO TRIGGER IT
            cell.calendarButton.setTitle(String(indexPath.row), forState: UIControlState.Normal)
            cell.calendarButton.addTarget(self, action: "syncCalendar:", forControlEvents: UIControlEvents.TouchUpInside)
            
            //(cell.eventImage).backgroundColor = UIColor(patternImage: UIImage(named: event.image!)!)

            return cell
    }
    
    func syncCalendar(sender: UIButton!) {
        
        let event = eventsCollection[Int(sender.titleLabel!.text!)!]
        let name = event.name
        let start = event.startDate
        let end = event.endDate
        
        // 1
        let eventStore = EKEventStore()
        let dateFormatter = NSDateFormatter()
            //2015-11-19T22:00:00.000Z
        //dateFormatter.dateFormat = "MMM dd, yyyy, HH:ss"
        dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ss.000Z"
        
        let startDate = dateFormatter.dateFromString(start!)
        
        let endDate = dateFormatter.dateFromString(end!)
        
        if(EKEventStore.authorizationStatusForEntityType(.Event) !=
            EKAuthorizationStatus.Authorized) {
                eventStore.requestAccessToEntityType(.Event, completion: {
                    granted, error in
                    self.createEvent(eventStore, title: name, startDate: startDate!, endDate: endDate!)
                })
                
                
        }
        else {
            createEvent(eventStore, title: name, startDate: startDate!, endDate: endDate!)
        }
    }
    
    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.saveEvent(event, span: .ThisEvent)
        } catch {
            print("Bad")
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
