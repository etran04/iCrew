//
//  RideShareStatusTableViewController.swift
//  CruApp
//
//  Created by Tammy Kong on 2/25/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit
import SwiftLoader


let kDriverHeader = "You will be a driver for..."
let kPassengerHeader = "You will be a passenger for..."

let gcm_id = "1234567"

//class RideSharePassenger {
//    var rideId:String
//    var passengerId:String
//    var eventId:String
//    var departureTime:String
//    var departureLoc1:String
//    var departureLoc2:String
//    var driverNumber:String
//    var driverName:String
//    
//    init(rideId:String, passengerId:String, eventId:String, departureTime:String, departureLoc1:String, departureLoc2:String, driverNumber:String, driverName:String) {
//        self.rideId = rideId
//        self.passengerId = passengerId
//        self.eventId = eventId
//        self.departureTime = departureTime
//        self.departureLoc1 = departureLoc1
//        self.departureLoc2 = departureLoc2
//        self.driverNumber = driverNumber
//        self.driverName = driverName
//    }
//}

//class PassengerData {
//    var id:String
//    var gcmId:String
//    var phoneNumber:String
//    var name:String
//    
//    init(id:String, gcmId:String, phoneNumber:String, name:String) {
//        self.id = id
//        self.gcmId = gcmId
//        self.phoneNumber = phoneNumber
//        self.name = name
//    }
//}

class RideShareDriver {
    var rideId:String
    var eventId:String
    var departureTime:String
    var departureLoc1:String
    var departureLoc2:String
    var availableSeats:Int
    var passengers = [Passenger]()
    
    init(rideId:String, eventId:String, departureTime:String, departureLoc1: String, departureLoc2:String, availableSeats:Int, passengers:[Passenger]) {
        self.rideId = rideId
        self.eventId = eventId
        self.departureTime = departureTime
        self.departureLoc1 = departureLoc1
        self.departureLoc2 = departureLoc2
        self.availableSeats = availableSeats
        self.passengers += passengers
    }
}

class RideShareStatusTableViewController: UITableViewController {
    
    var eventNames = [String]()
    var eventIds = [String]()
    
    /* Header titles, can be changed if needed */
    let headerTitles = [kDriverHeader, kPassengerHeader]
    
    /* Arrays used to hold each section of user's rideshare data */
    var driverCollection = [RideShareDriver]()
    var passengerCollection = [Passenger]()
    var passengersData = [Passenger]()
    var tableData = [[AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Starts the loading spinner
        SwiftLoader.show(animated: true)
        
        tableView.separatorStyle = .None

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Replaces the extra cells at the end with a clear view
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Gets the orders from Firebase
        self.fetchStatuses()
        
        tableView.separatorStyle = .SingleLine
    }
    
    func fetchStatuses() {
        driverCollection = [RideShareDriver]()
        passengerCollection = [Passenger]()
        tableData = [[AnyObject]]()
        DBClient.getData("event", dict: setEvents)
        
        SwiftLoader.hide()

        self.tableView.reloadData()
    }
    
    // Obtain event information from the database to an Object
    func setEvents(events: NSArray) {
        for event in events {
            let name = event["name"] as! String
            let id = event["_id"] as! String
            self.eventNames.append(name)
            self.eventIds.append(id)
        }
        DBClient.getData("passenger", dict: setPassenger)

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
        DBClient.getData("ride", dict: setRides)
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
            
            if(ride["direction"]! != nil) {
                direction = ride["direction"] as! String
            }
            
            let zipcode = ride["location"]?!.objectForKey("postcode") as! String
            let state = ride["location"]?!.objectForKey("state") as! String
            var city = ""
            
            if(ride["location"]?!.objectForKey("suburb") != nil) {
                city = ride["location"]?!.objectForKey("suburb") as! String
            }
            let street = ride["location"]?!.objectForKey("street1") as! String
            let country = ride["location"]?!.objectForKey("country") as! String
            
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
                let rideObj = RideShareDriver(rideId:rideId, eventId:event, departureTime:time, departureLoc1:street, departureLoc2:location2, availableSeats:availableSeats, passengers:passengersInfo)
                driverCollection.append(rideObj)
            }
        }
        
        self.tableData = [self.driverCollection, self.passengerCollection]
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableData.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numCellsInSection = tableData[section].count
        
        if (numCellsInSection == 0) {
            return 1
        }
        
        return numCellsInSection
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var cell = UITableViewCell()
        
        switch (headerTitles[indexPath.section]) {
        case kDriverHeader:
            if (self.driverCollection.count > 0) {
                cell = tableView.dequeueReusableCellWithIdentifier("DriverCell")!
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier("NoDataCell")!
            }
            break
        case kPassengerHeader:
            if (self.passengerCollection.count > 0) {
                cell = tableView.dequeueReusableCellWithIdentifier("PassengerCell")!
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier("NoDataCell")!
            }
            break
        default:
            break
        }
        return cell.contentView.bounds.size.height
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        }
        
        return nil
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(headerTitles[indexPath.section])
        switch(headerTitles[indexPath.section]) {
            case kDriverHeader:
                var alert = UIAlertView()
                alert.delegate = self
                alert.title = "Passengers"
                let driver = driverCollection[indexPath.row] as RideShareDriver
            
                if (driver.passengers.count != 0) {
                    var msg = ""
                    
                    for index in 0...(driver.passengers.count - 1) {
                        
                        var number = String(driver.passengers[index].phoneNumber)
                        number = number.insert("(", ind: 0)
                        number = number.insert(") ", ind: 4)
                        number = number.insert(" - ", ind: 9)

                        msg += driver.passengers[index].name + " " + number + "\n"
                    }
                    alert.message = msg
                } else {
                    alert.message = "No passengers at this time."
                }
                alert.addButtonWithTitle("OK")
                alert.show()
                break

            default:
                break
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = UITableViewCell()
        
        switch (headerTitles[indexPath.section]) {
            case kDriverHeader:
                if (self.driverCollection.count > 0) {
                    cell = tableView.dequeueReusableCellWithIdentifier("DriverCell", forIndexPath: indexPath)
                    populateDriverCell(indexPath, cell: (cell as! DriverStatusTableViewCell))
                } else {
                    cell = tableView.dequeueReusableCellWithIdentifier("NoDataCell", forIndexPath: indexPath)
                }
                break
            case kPassengerHeader:
                if (self.passengerCollection.count > 0) {
                    cell = tableView.dequeueReusableCellWithIdentifier("PassengerCell", forIndexPath: indexPath)
                    populatePassengerCell(indexPath, cell: (cell as! PassengerStatusTableViewCell))
                } else {
                    cell = tableView.dequeueReusableCellWithIdentifier("NoDataCell", forIndexPath: indexPath)
                }
                break
            default:
                break
        }
        
        return cell
    }
    
    /* Helper function for filling in driver cell with its information */
    func populateDriverCell(indexPath: NSIndexPath, cell: DriverStatusTableViewCell) {
        cell.tableController = self
        
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
        cell.departureLoc1.text = driver.departureLoc1
        cell.departureLoc2.text = driver.departureLoc2

        cell.availableSeats.text = String(driver.availableSeats) + " available seats left"
    }
    
    /* Callback for when a cancel button is pressed in a driver cell. Input is the row of the cell at which it's pressed */
    func cancelDriver(row: Int) {
        let titleMsg = "Are you sure?"
        let msg = "Are you sure you want to cancel your ride offering?"
        
        let confirmDialog = UIAlertController(title: titleMsg, message: msg, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Confirm", style: .Default) { (UIAlertAction) -> Void in

            let params = ["ride_id": self.driverCollection[row].rideId]
            
            do {
                let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
                
                DBClient.postData("ride/dropRide", body:body)
                
                for pssngr in self.passengerCollection {
                    if (pssngr.rideId == self.driverCollection[row].rideId) {
                        self.passengerCollection.removeAtIndex(row)
                    }
                }
                
                self.driverCollection.removeAtIndex(row)

            
                self.tableData = [self.driverCollection, self.passengerCollection]
                
                self.tableView.reloadData()
                
            } catch {
                print("Error sending data to database")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        confirmDialog.addAction(okAction)
        confirmDialog.addAction(cancelAction)
        
        self.presentViewController(confirmDialog, animated: true, completion: nil)
    }
    
    /* Helper function for filling in passenger cell with its information */
    func populatePassengerCell(indexPath: NSIndexPath, cell: PassengerStatusTableViewCell) {
        cell.tableController = self
        
        let passenger = passengerCollection[indexPath.row]

        
        for index in 0...(eventIds.count - 1) {
            if(eventIds[index] == passenger.eventId) {
                cell.eventName.text = eventNames[index]
                cell.eventName.font = UIFont.boldSystemFontOfSize(20)
                break
            }
        }
        
        cell.driverName.text = passenger.driverName
        
        var number = String(passenger.driverNumber)

        number = number.insert("(", ind: 0)
        number = number.insert(") ", ind: 4)
        number = number.insert(" - ", ind: 9)
        cell.driverNumber.text = number

        cell.departureLoc1.text = passenger.departureLoc1
        cell.departureLoc2.text = passenger.departureLoc2
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.dateFromString(passenger.departureTime)
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        cell.departureTime.text = "Departing on " + dateFormatter.stringFromDate(date!)
    
    }
    
    /* Callback for when a cancel button is pressed in a passenger cell. Input is the row of the cell at which it's pressed */
    func cancelPassenger(row: Int) {
        let titleMsg = "Are you sure?"
        let msg = "Are you sure you want to cancel your spot in the ride?"
        
        let confirmDialog = UIAlertController(title: titleMsg, message: msg, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Confirm", style: .Default) { (UIAlertAction) -> Void in
            let params = ["ride_id": self.passengerCollection[row].rideId, "passenger_id": self.passengerCollection[row].passengerId]
            print("rideId: " + self.passengerCollection[row].rideId)
            print("passengerId: " + self.passengerCollection[row].passengerId)
            do {
                let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
                DBClient.postData("ride/dropPassenger", body:body)
                
                self.passengerCollection.removeAtIndex(row)
                self.tableData = [self.driverCollection, self.passengerCollection]
                
                
                self.tableView.reloadData()
                
            } catch {
                print("Error sending data to database")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        confirmDialog.addAction(okAction)
        confirmDialog.addAction(cancelAction)
        
        self.presentViewController(confirmDialog, animated: true, completion: nil)
    }
    
   
    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Choose an option", message: "What would you like to do?", preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        
        //Create and add first option action
        let offerRideAction: UIAlertAction = UIAlertAction(title: "Offer a ride", style: .Default)
            { action -> Void in
                self.performSegueWithIdentifier("toDriverQ", sender: self)
        }
        actionSheetController.addAction(offerRideAction)
        
        //Create and add a second option action
        let requestRideAction: UIAlertAction = UIAlertAction(title: "Request a ride", style: .Default)
            { action -> Void in
                self.performSegueWithIdentifier("toRiderQ", sender: self)
                
        }
        actionSheetController.addAction(requestRideAction)
        
        //We need to provide a popover sourceView when using it on iPad
        //            actionSheetController.popoverPresentationController?.sourceView = sender as UIView
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
    }
    
}
