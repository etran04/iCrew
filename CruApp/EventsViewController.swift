//
//  EventsViewController.swift
//  CruApp
//
//  Created by Tammy Kong on 11/30/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import UIKit
import EventKit
import Alamofire
import SafariServices

class EventsViewController: UITableViewController {

    //var events:[Event] = eventsData
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var textButton: UIBarButtonItem!
    
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
        
        self.textButton.target = self
        self.textButton.action = "text:"
    }
    
    override func viewDidAppear(animated: Bool) {
        if (self.revealViewController() != nil) {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func text(sender: UIBarButtonItem) {
        print("texting...")
        let twilioUsername = "ACc18e4b9385be579bdb48ca5526414403"
        let twilioPassword = "c5e0f0de4c90c803595851a7554c9a98"
        
        let data = [
            "To" : "+17078038796",
            "From" : "+17074193527",
            "Body" : "It works!"
        ]
        
        Alamofire.request(.POST, "https://\(twilioUsername):\(twilioPassword)@api.twilio.com/2010-04-01/Accounts/\(twilioUsername)/Messages", parameters: data)
            .responseData { response in
                print(response.request)
                print(response.response)
                print(response.result)
        }
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
    }
    
    
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

        //date formatting
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let startDate = dateFormatter.dateFromString(event.startDate!)
        let endDate = dateFormatter.dateFromString(event.endDate!)
        let calendar = NSCalendar.currentCalendar()
        let startComp = calendar.components([.Hour, .Minute, .Month, .Day, .Year], fromDate: startDate!)
        let endComp = calendar.components([.Hour, .Minute, .Month, .Day, .Year], fromDate: endDate!)
        cell.eventName.text = event.name
        cell.eventStartTime.text = "Start Time: " + String(startComp.hour) + ":" + String(format: "%02d", startComp.minute)
        cell.eventDate.text = "Date: " + String(startComp.month) + "/" + String(startComp.day) + "/" + String(startComp.year) + " - " + String(endComp.month) + "/" + String(endComp.day) + "/" + String(endComp.year)
        cell.eventLocation.text = "Where: " + (event.location?.suburb)! + ", " + (event.location?.state)!
        // Calendar button
        cell.calendarButton.setTitle(String(indexPath.row), forState: UIControlState.Normal)
        cell.calendarButton.addTarget(self, action: "syncCalendar:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Facebook button
        if (event.url != "") {
            cell.facebookButton.setTitle(String(indexPath.row), forState: UIControlState.Normal)
            cell.facebookButton.addTarget(self, action: "openFacebook:", forControlEvents: .TouchUpInside)
        } else {
            cell.facebookButton.enabled = false
        }
        
        // Load event image is available
        if (event.image != nil) {
            let url = NSURL(string: event.image!)
            let data = NSData(contentsOfURL: url!)
            let image = UIImage(data: data!)
            let imageView = UIImageView(image: image)
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            imageView.clipsToBounds = true
            cell.eventImage.bounds.size.height = 163
            cell.eventImage.bounds.size.width = 375
            imageView.frame = cell.eventImage.bounds
            cell.eventImage.contentMode = UIViewContentMode.ScaleAspectFit
            cell.eventImage.addSubview(imageView)
        }

        return cell
    }
    
    func openFacebook(sender:UIButton!) {
        let event = eventsCollection[Int(sender.titleLabel!.text!)!]
        
        if let url = NSURL(string: event.url) {
            let vc = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
                presentViewController(vc, animated: false, completion: nil)
        }
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
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

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
        let alertController = UIAlertController(title: name, message:
            "Event synced to calendar", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
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
