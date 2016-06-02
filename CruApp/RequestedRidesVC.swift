//
//  RequestedRidesVC.swift
//  CruApp
//
//  Created by Eric Tran on 5/25/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit
import SwiftLoader
import DZNEmptyDataSet

class RequestedRidesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
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
    
    /* Helper function for filling in passenger cell with its information */
    func populatePassengerCell(indexPath: NSIndexPath, cell: RiderStatusCell) {
        
        let passenger = passengerCollection[indexPath.row]
        
        
        for index in 0...(eventIds.count - 1) {
            if(eventIds[index] == passenger.eventId) {
                cell.eventName.text = eventNames[index]
                cell.eventName.font = UIFont.boldSystemFontOfSize(20)
                break
            }
        }
        
        var number = String(passenger.driverNumber)
        
        number = number.insert("(", ind: 0)
        number = number.insert(") ", ind: 4)
        number = number.insert(" - ", ind: 9)
        cell.driversCell.text = passenger.driverName + "@" + number
        
        cell.departLoc1.text = passenger.departureLoc1
        cell.departLoc2.text = passenger.departureLoc2
        cell.departLoc3.text = passenger.departureLoc3
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.dateFromString(passenger.departureTime)
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        cell.departureTime.text = dateFormatter.stringFromDate(date!)
        
    }
    
    // MARK: - Table view data source
    
    /* Asks the data source to return the number of sections in the table view. Default is 1. */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    /* Dynamically size the number of rows to match the number of statuses we have */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passengerCollection.count
//        return 1
    }
    
    /* Loads each individual cell in the table with a offered status */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        cell = tableview.dequeueReusableCellWithIdentifier("RequestStatusCell", forIndexPath: indexPath) as! RiderStatusCell
        populatePassengerCell(indexPath, cell: cell as! RiderStatusCell)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        cancelPassenger(indexPath.row)
        tableview.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    /* Callback for when a cancel button is pressed in a passenger cell. Input is the row of the cell at which it's pressed */
    func cancelPassenger(row: Int) {
        let titleMsg = "Would you like to cancel this ride?"
        let msg = "Are you sure you want to cancel your spot in this ride?"
        
        let confirmDialog = UIAlertController(title: titleMsg, message: msg, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Confirm", style: .Default) { (UIAlertAction) -> Void in
            //            let params = ["ride_id": self.passengerCollection[row].rideId, "passenger_id": self.passengerCollection[row].passengerId]
            let rideId = self.passengerCollection[row].rideId
            let passengerId = self.passengerCollection[row].passengerId
            //            do {
            //                let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            //                DBClient.deleteData("rides/dropPassenger", body:body)
            
            DBClient.deleteData("rides/" + rideId + "/passengers/" + passengerId)
            self.passengerCollection.removeAtIndex(row)
            
            
            self.tableview.reloadData()
            //
            //            } catch {
            //                print("Error sending data to database")
            //            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        
        confirmDialog.addAction(okAction)
        confirmDialog.addAction(cancelAction)
        
        self.presentViewController(confirmDialog, animated: true, completion: nil)
    }
    
    // MARK: - DZN Empty data set methods
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "You currently are not requesting any rides to an event."
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Go add one!"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }
}

