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
        self.tableview.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.fetchStatuses()
        
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
            else {
                zipcode = "N/A"
            }
            
            if(ride["location"]?!.objectForKey("state") != nil && !(ride["location"]?!.objectForKey("state") is NSNull)) {
                state = ride["location"]?!.objectForKey("state") as! String
            } else {
                state = "N/A'"
            }
            
            if(ride["location"]?!.objectForKey("suburb") != nil && !(ride["location"]?!.objectForKey("suburb") is NSNull)) {
                city = ride["location"]?!.objectForKey("suburb") as! String
            } else {
                city = "N/A"
            }
            
            if(ride["location"]?!.objectForKey("street1") != nil && !(ride["location"]?!.objectForKey("street1") is NSNull)) {
                street = ride["location"]?!.objectForKey("street1") as! String
            } else {
                street = "N/A"
            }
            
            if(ride["location"]?!.objectForKey("country") != nil && !(ride["location"]?!.objectForKey("country") is NSNull)) {
                country = ride["location"]?!.objectForKey("country") as! String
            } else {
                country = "N/A"
            }
            
            let location2 = city + ", " + state
            
            let location3 = country + " " + zipcode
            
            
            for pssngr in passengers{
                for data in passengersData {
                    if data.passengerId == pssngr {
                        passengersInfo.append(data)
                        
                        //if user is a passenger
                        if(gcm_id == data.gcmId) {
                            let passengerObj = Passenger(rideId:rideId, passengerId:pssngr, eventId:event, departureTime:time, departureLoc1: street, departureLoc2: location2, departureLoc3: location3, driverNumber:driverNumber, driverName:driverName)
                            passengerCollection.append(passengerObj)
                        }
                    }
                }
            }
            
            //if user is a driver
            if(gcm_id == gcmId) {
                let rideObj = Driver(rideId:rideId, eventId:event, departureTime:time, departureLoc1:street, departureLoc2:location2, departureLoc3: location3, availableSeats:availableSeats, passengers:passengersInfo)
                driverCollection.append(rideObj)
            }
        }
        
        // Sets up the controller to display notification screen if no ridesharing can be accessed
        self.tableview.emptyDataSetSource = self;
        self.tableview.emptyDataSetDelegate = self;
        
        self.tableview.reloadData()
        
        SwiftLoader.hide()

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
        
        var dateAndTime = dateFormatter.stringFromDate(date!).componentsSeparatedByString(",")
        cell.departureDate.text = dateAndTime[0]
        cell.departureTime.text = dateAndTime[1]
        
        cell.departLoc1.text = driver.departureLoc1
        cell.departLoc2.text = driver.departureLoc2
        cell.departLoc3.text = driver.departureLoc3
        
        cell.numSeats.text = String(driver.availableSeats) + " seats"
    }
    
    // MARK: - Table view data source
    
    /* Asks the data source to return the number of sections in the table view. Default is 1. */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    /* Dynamically size the number of rows to match the number of statuses we have */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return driverCollection.count
//        return 1
    }
    
    /* Loads each individual cell in the table with a offered status */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        cell = tableview.dequeueReusableCellWithIdentifier("OfferedStatusCell", forIndexPath: indexPath) as! DriverStatusCell
        populateDriverCell(indexPath, cell: cell as! DriverStatusCell)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        displayDetailsOfferedRide(indexPath)
        tableview.deselectRowAtIndexPath(indexPath, animated: true)

    }

    // Helper function for viewing more information about an offered ride 
    func displayDetailsOfferedRide(indexPath: NSIndexPath) {
        var message: String!
        let driver = driverCollection[indexPath.row]
        if (driver.passengers.count != 0) {
            var msg = ""
    
            for index in 0...(driver.passengers.count - 1) {
                var number = String(driver.passengers[index].phoneNumber)
                number = number.insert("(", ind: 0)
                number = number.insert(") ", ind: 4)
                number = number.insert(" - ", ind: 9)
        
                msg += driver.passengers[index].name + " " + number + "\n"
            }
            message = msg
        } else {
            message = "No passengers at this time."
        }
    
        let alert = UIAlertController(title: "Current ride!", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .Default) { _ in })
        alert.addAction(UIAlertAction(title: "Cancel Ride", style: .Default) { _ in self.cancelDriver(indexPath.row)})
        self.presentViewController(alert, animated: true){}
    }
    
    /* Callback for when a cancel button is pressed in a driver cell. Input is the row of the cell at which it's pressed */
    func cancelDriver(row: Int) {
        let titleMsg = "Are you sure?"
        let msg = "Are you sure you want to cancel your ride offering?"
        
        let confirmDialog = UIAlertController(title: titleMsg, message: msg, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Yes", style: .Default) { (UIAlertAction) -> Void in
            
            let rideId = self.driverCollection[row].rideId;
            DBClient.deleteData("rides/" + rideId)
            
            for pssngr in self.passengerCollection {
                if (pssngr.rideId == self.driverCollection[row].rideId) {
                    self.passengerCollection.removeAtIndex(row)
                }
            }
            
            self.driverCollection.removeAtIndex(row)
            self.tableview.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .Default, handler: nil)
        
        confirmDialog.addAction(okAction)
        confirmDialog.addAction(cancelAction)
        
        self.presentViewController(confirmDialog, animated: true, completion: nil)
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
