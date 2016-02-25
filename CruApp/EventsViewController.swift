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
import ReachabilitySwift

class EventsViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var eventsCollection = [Event]()
    var ministryCollection: [MinistryData] = []
    
    //    var service:EventService!
    //    var settings:Settings!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        ministryCollection = UserProfile.getMinistries()
        
        var dbClient: DBClient!
        dbClient = DBClient()
        dbClient.getData("event", dict: setEvents)
    }
    
    override func viewDidAppear(animated: Bool) {
        checkInternet()
        
        if (self.revealViewController() != nil) {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        print("minisitries -")
        print(ministryCollection.count)
    }
    
    //obtain information from the database to an Object
    //TODO: Move function into Event.swift
    func setEvents(event:NSDictionary) {
        //self.tableView.beginUpdates()

        var existsInMinistry = false
        
        if (event["parentMinistry"] == nil) {
            let parentMinistries = event["parentMinistries"] as! [String]
            
            for ministryId in parentMinistries {
                for ministry in ministryCollection {
                    if (ministryId == ministry.id) {
                        existsInMinistry = true;
                    }
                }
            }
        }
        else {
            let ministryId = event["parentMinistry"] as! String
            
            for ministry in ministryCollection {
                if (ministry.id == ministryId) {
                    existsInMinistry = true;
                }
            }
        }
        
        if (!existsInMinistry) {
            return;
        }
        
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
    }
    
    /* Determines whether or not the device is connected to WiFi or 4g. Alerts user if they are not.
     * Without internet, data might not populate, aside from cached data */
    func checkInternet() {
        /*
        * Tokens is a inner class, used to make sure internet connectivity is check
        * only once when the app is intially launched.
        */
        struct Tokens {
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Tokens.token) {

            // Checks for internet connectivity (Wifi/4G)
            let reachability: Reachability
            do {
                reachability = try Reachability.reachabilityForInternetConnection()
            } catch {
                print("Unable to create Reachability")
                return
            }
            
            // If device does have internet
            reachability.whenReachable = { reachability in
                dispatch_async(dispatch_get_main_queue()) {
                    if reachability.isReachableViaWiFi() {
                        print("Reachable via WiFi")
                    } else {
                        print("Reachable via Cellular")
                    }
                }
            }
            
            reachability.whenUnreachable = { reachability in
                dispatch_async(dispatch_get_main_queue()) {
                    // If no internet, display an alert notifying user they have no internet connectivity
                    let g_alert = UIAlertController(title: "Checking for Internet...", message: "If this dialog appears, please check to make sure you have internet connectivity. ", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        // Dismiss alert dialog
                        print("Dismissed No Internet Dialog")
                    }
                    g_alert.addAction(OKAction)
                    self.presentViewController(g_alert, animated: true, completion: nil)
                }
            }
            
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
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
        cell.eventLocation.text = "Where: " + (event.location?.suburb)! + ", " + (event.location?.state)!

        //date formatting
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let startDate = dateFormatter.dateFromString(event.startDate!)
        
        //day of month formatter
        dateFormatter.dateFormat = "d"
        cell.eventDayDate.text = dateFormatter.stringFromDate(startDate!)
        
        //month formatter
        dateFormatter.dateFormat = "MMM"
        cell.eventMonthDate.text = dateFormatter.stringFromDate(startDate!)
        
        //time formatter
        dateFormatter.dateFormat = "H:mm"
        dateFormatter.timeStyle = .ShortStyle
        cell.eventStartTime.text = "Start Time: " + dateFormatter.stringFromDate(startDate!)
        
        return cell
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
    
    
    // MARK: - Navigation
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let eventDetailViewController = segue.destinationViewController as! EventDetailsViewController
        if let selectedEventCell = sender as? EventViewCell {
            let indexPath = tableView.indexPathForCell(selectedEventCell)!
            let selectedEvent = eventsCollection[indexPath.row]
            eventDetailViewController.event = selectedEvent
        }
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    
    
    }

    
}
