//
//  OfferedRidesVC.swift
//  CruApp
//
//  Created by Eric Tran on 5/25/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit
import SwiftLoader
import DZNEmptyDataSet

class OfferedRidesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    @IBOutlet weak var tableview: UITableView!
    
    /* Arrays used to hold each section of user's rideshare data */
    var driverCollection = [Driver]()
    var passengerCollection = [Passenger]()
    var passengersData = [Passenger]()
    var eventNames = [String]()
    var eventIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.separatorStyle = .SingleLine
        
        self.fetchStatuses()
    }
    
    override func viewDidAppear(animated: Bool) {
        // Replaces the extra cells at the end with a clear view
        self.tableview.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func fetchStatuses() {
        SwiftLoader.show(title: "Loading...", animated: true)
        driverCollection = [Driver]()
        DBClient.getData("events", dict: setEvents)
    }

    // Obtain event information from the database to an Object
    func setEvents(events: NSArray) {
        for event in events {
            let name = event["name"] as! String
            let id = event["_id"] as! String
            self.eventNames.append(name)
            self.eventIds.append(id)
        }
        DBClient.getData("passengers", dict: setPassenger)
        
    }
    
    func setPassenger(passengers:NSArray){
        for passenger in passengers {
            let passengerId = passenger["_id"] as! String
            let gcmId = passenger["gcm_id"] as! String
            let phoneNumber = passenger["phone"] as! String
            let name = passenger["name"] as! String
            
            let passengerObj = Passenger(passengerId:passengerId, gcmId:gcmId, phoneNumber:phoneNumber, name:name)
            passengersData.append(passengerObj)
        }
        DBClient.getData("rides", dict: setRides)
    }
    
    func setRides(rides:NSArray) {
        for ride in rides {
            let gcmId = ride["gcm_id"] as! String
            let rideId = ride["_id"] as! String
            let event = ride["event"] as! String
            let driverNumber = ride["driverNumber"] as! String
            let driverName = ride["driverName"] as! String
            let time = ride["time"] as! String
            let passengers = ride["passengers"] as! [String]
            let availableSeats = (ride["seats"] as! Int) - (passengers.count)
            var passengersInfo = [Passenger]()
            
            var direction = ""
            var street = ""
            var city = ""
            var zipcode = ""
            var suburb = ""
            var state = ""
            var country = ""
            
            if(ride["direction"]! != nil) {
                direction = ride["direction"] as! String
            }
            
            if(ride["location"]?!.objectForKey("postcode") != nil && !(ride["location"]?!.objectForKey("postcode") is NSNull)) {
                zipcode = ride["location"]?!.objectForKey("postcode") as! String
            }
            
            if(ride["location"]?!.objectForKey("state") != nil && !(ride["location"]?!.objectForKey("state") is NSNull)) {
                state = ride["location"]?!.objectForKey("state") as! String
            }
            
            if(ride["location"]?!.objectForKey("suburb") != nil && !(ride["location"]?!.objectForKey("suburb") is NSNull)) {
                city = ride["location"]?!.objectForKey("suburb") as! String
            }
            
            if(ride["location"]?!.objectForKey("street1") != nil && !(ride["location"]?!.objectForKey("street1") is NSNull)) {
                street = ride["location"]?!.objectForKey("street1") as! String
            }
            
            if(ride["location"]?!.objectForKey("country") != nil && !(ride["location"]?!.objectForKey("country") is NSNull)) {
                country = ride["location"]?!.objectForKey("country") as! String
            }
            
            let location2 = city + ", " + state + ", " + country + " " + zipcode
            
            
            for pssngr in passengers{
                for data in passengersData {
                    if data.passengerId == pssngr {
                        passengersInfo.append(data)
                        
                        //if user is a passenger
                        if(gcm_id == data.gcmId) {
                            let passengerObj = Passenger(rideId:rideId, passengerId:pssngr, eventId:event, departureTime:time, departureLoc1: street, departureLoc2: location2, driverNumber:driverNumber, driverName:driverName)
                            passengerCollection.append(passengerObj)
                        }
                    }
                }
            }
            
            //if user is a driver
            if(gcm_id == gcmId) {
                let rideObj = Driver(rideId:rideId, eventId:event, departureTime:time, departureLoc1:street, departureLoc2:location2, availableSeats:availableSeats, passengers:passengersInfo)
                driverCollection.append(rideObj)
            }
        }
        
        SwiftLoader.hide()
        
        // Sets up the controller to display notification screen if no ridesharing can be accessed
        self.tableview.emptyDataSetSource = self;
        self.tableview.emptyDataSetDelegate = self;
        
        self.tableview.reloadData()
    }
    
    /* Helper function for filling in driver cell with its information */
    func populateDriverCell(indexPath: NSIndexPath, cell: DriverStatusCell) {
        let driver = driverCollection[indexPath.row]
        
        for index in 0...(eventIds.count - 1) {
            if(eventIds[index] == driver.eventId) {
                cell.eventName.text = eventNames[index]
                cell.eventName.font = UIFont.boldSystemFontOfSize(20)
                break
            }
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.dateFromString(driver.departureTime)
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        cell.departureTime.text = "Departure on " + dateFormatter.stringFromDate(date!)
        cell.departLoc1.text = driver.departureLoc1
        cell.departLoc2.text = driver.departureLoc2
        
        cell.numSeats.text = String(driver.availableSeats) + " seats free"
    }
    
    // MARK: - Table view data source
    
    /* Asks the data source to return the number of sections in the table view. Default is 1. */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    /* Dynamically size the number of rows to match the number of statuses we have */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return driverCollection.count
        return 4
    }
    
    /* Loads each individual cell in the table with a offered status */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        cell = tableview.dequeueReusableCellWithIdentifier("OfferedStatusCell", forIndexPath: indexPath) as! DriverStatusCell
//        populateDriverCell(indexPath, cell: cell as! DriverStatusCell)
        
        return cell
    }
    
    // MARK: - DZN Empty data set methods 
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "You currently are not offering any rides to an event."
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Go add one!"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }
}
