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
import DZNEmptyDataSet
import SwiftLoader

class EventsViewController: UITableViewController, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var eventsCollection = [Event]()
    var ministryCollection: [MinistryData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // A little trick for removing the cell separators
        self.tableView.tableFooterView = UIView()
        
        // Checks internet, and if internet connectivity is there, load from database
        checkInternet()

    }
    
    override func viewDidAppear(animated: Bool) {
        if (self.revealViewController() != nil) {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    /* Determines whether or not the device is connected to WiFi or 4g. Alerts user if they are not.
     * Without internet, data might not populate, aside from cached data */
    func checkInternet() {
        
        // Checks for internet connectivity (Wifi/4G)
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }

        SwiftLoader.show(title: "Loading...", animated: true)

        // If device does have internet
        reachability.whenReachable = { reachability in
            dispatch_async(dispatch_get_main_queue()) {
                if reachability.isReachableViaWiFi() {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
                
                // Get the user's ministries, and load the events
                self.ministryCollection = UserProfile.getMinistries()
                DBClient.getData("events", dict: self.setEvents)
            }
        }
        
        reachability.whenUnreachable = { reachability in
            dispatch_async(dispatch_get_main_queue()) {
                
                // If unreachable, hide the loading indicator anyways
                SwiftLoader.hide()
                
                // If no internet, display an alert notifying user they have no internet connectivity
                let g_alert = UIAlertController(title: "Checking for Internet...", message: "If this dialog appears, please check to make sure you have internet connectivity. ", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    // Dismiss alert dialog
                    print("Dismissed No Internet Dialog")
                }
                g_alert.addAction(OKAction)
                
                // Sets up the controller to display notification screen if no events populate
                self.tableView.emptyDataSetSource = self;
                self.tableView.emptyDataSetDelegate = self;
                self.tableView.reloadEmptyDataSet()
                
                self.presentViewController(g_alert, animated: true, completion: nil)
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    
    //obtain information from the database to an Object
    //TODO: Move function into Event.swift
    func setEvents(events:NSArray) {
        
        for event in events {

            var existsInMinistry = false
        
            if (event["ministries"]! != nil) {
                let parentMinistries = event["ministries"] as! [String]
            
                for ministryId in parentMinistries {
                    for ministry in ministryCollection {
                        if (ministryId == ministry.id) {
                            existsInMinistry = true;
                        }
                    }
                }
            }
        
            if (!existsInMinistry) {
                continue
            }
        
            let name = event["name"] as! String
            let startDate = event["startDate"] as! String!
            let endDate = event["endDate"] as! String!
            let description = event["description"] as! String
        
            let postcode = event["location"]?!.objectForKey("postcode") as! String
            let state = event["location"]?!.objectForKey("state") as! String
            let suburb = event["location"]?!.objectForKey("suburb") as! String
            let street1 = event["location"]?!.objectForKey("street1") as! String
            
            var country = ""
            if(event["location"]?!.objectForKey("country") is NSNull) {
            } else {
                country = event["location"]?!.objectForKey("country") as! String
            }
            let location = Location(
                postcode: postcode,
                state: state,
                suburb: suburb,
                street1: street1,
                country: country)
            
            var image : String
            if (event["imageLink"]! == nil) {
                image = ""
            }
            else {
                image = event["imageLink"] as! String!
            }
            
            var imageSq : String
            if(event["squareImageLink"]! == nil) {
                imageSq = ""
            }
            else {
                imageSq = event["squareImageLink"] as! String!
            }
        
            let url = event["url"] as! String
            let rideShareEnabled = event["rideSharing"] as! Bool
        
            var eventObj = Event(name: name, startDate: startDate, endDate: endDate, location: location, image: image, imageSq: imageSq, description: description, url: url, rideShareFlag: rideShareEnabled)
            
            // Caches the square image of event
            if(imageSq == "") {
                eventObj.displayingImage = UIImage(named: "CruSquareIcon")
            } else {
                if let imageUrl = NSURL(string: eventObj.imageSq!) {
                    if let data = NSData(contentsOfURL: imageUrl) {
                        eventObj.displayingImage = UIImage(data: data)
                    }
                }
            }
            
            
        
            eventsCollection.append(eventObj)
        }
        
        SwiftLoader.hide()
        self.tableView.reloadData()
        
        // Sets up the controller to display notification screen if no events populate
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;        
        tableView.reloadEmptyDataSet()
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
        cell.eventName.font = UIFont.boldSystemFontOfSize(20)
        cell.eventLocation.text = (event.location?.suburb)! + ", " + (event.location?.state)!
        
        if let image = event.displayingImage {
            cell.eventImage.image = image
        }
        
        //date formatting
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let startDate = dateFormatter.dateFromString(event.startDate!)
        
        //date formatter
        dateFormatter.dateFormat = "MMM d, "
        cell.eventStartTime.text = dateFormatter.stringFromDate(startDate!)
        
        //time formatter
        dateFormatter.dateFormat = "H:mm"
        dateFormatter.timeStyle = .ShortStyle
        cell.eventStartTime.text = cell.eventStartTime.text! + dateFormatter.stringFromDate(startDate!)
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let eventDetailViewController = segue.destinationViewController as! EventDetailsViewController
        if let selectedEventCell = sender as? EventViewCell {
            let indexPath = tableView.indexPathForCell(selectedEventCell)!
            let selectedEvent = eventsCollection[indexPath.row]
            eventDetailViewController.event = selectedEvent
        }
    }

    
    // MARK: - DZNEmptySet Delegate/DataSource methods
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No events to display!"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Please check back later or add more ministries."
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let str = "Click to refresh!"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        checkInternet()
    }
}
