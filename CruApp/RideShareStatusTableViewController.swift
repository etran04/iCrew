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

class RideSharePassenger {
    var rideId:String
    var passengerId:String
    var eventId:String
    var departureTime:String
    var driverNumber:String
    var driverName:String
    
    init(rideId:String, passengerId:String, eventId:String, departureTime:String, driverNumber:String, driverName:String) {
        self.rideId = rideId
        self.passengerId = passengerId
        self.eventId = eventId
        self.departureTime = departureTime
        self.driverNumber = driverNumber
        self.driverName = driverName
    }
}

class PassengerData {
    var id:String
    var gcmId:String
    var phoneNumber:String
    var name:String
    
    init(id:String, gcmId:String, phoneNumber:String, name:String) {
        self.id = id
        self.gcmId = gcmId
        self.phoneNumber = phoneNumber
        self.name = name
    }
}

class RideShareDriver {
    var rideId:String
    var eventId:String
    var departureTime:String
    var availableSeats:Int
    var passengers = [PassengerData]()
    
    init(rideId:String, eventId:String, departureTime:String, availableSeats:Int, passengers:[PassengerData]) {
        self.rideId = rideId
        self.eventId = eventId
        self.departureTime = departureTime
        self.availableSeats = availableSeats
        self.passengers += passengers
    }
}

class RideShareStatusTableViewController: UITableViewController {
    
    /* Header titles, can be changed if needed */
    let headerTitles = [kDriverHeader, kPassengerHeader]
    
    /* Arrays used to hold each section of user's rideshare data */
    var driverCollection = [RideShareDriver]()
    var passengerCollection = [RideSharePassenger]()
    var passengersData = [PassengerData]()
    
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
        passengerCollection = [RideSharePassenger]()
        tableData = [[AnyObject]]()
        
        var dbClient: DBClient!
        dbClient = DBClient()
        dbClient.getData("passenger", dict: setPassenger)
        dbClient.getData("ride", dict: setRides)
        
        SwiftLoader.hide()
        
        self.tableView.reloadData()
    }
    
    
    func setPassenger(passengers:NSArray){
        for passenger in passengers {
            let id = passenger["_id"] as! String
            let gcmId = passenger["gcm_id"] as! String
            let phoneNumber = passenger["phone"] as! String
            let name = passenger["name"] as! String
        
            let passengerObj = PassengerData(id:id, gcmId:gcmId, phoneNumber:phoneNumber, name:name)
            passengersData.append(passengerObj)
        }
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
            var passengersInfo = [PassengerData]()
            
            for pssngr in passengers{
                for data in passengersData {
                    if data.id == pssngr {
                        passengersInfo.append(data)
                    
                        //if user is a passenger
                        if(gcm_id == data.gcmId) {
                            let passengerObj = RideSharePassenger(rideId:rideId, passengerId:pssngr, eventId:event, departureTime:time, driverNumber:driverNumber, driverName:driverName)
                            passengerCollection.append(passengerObj)
                        }
                    }
                }
            }
        
            //if user is a driver
            if(gcm_id == gcmId) {
                let rideObj = RideShareDriver(rideId:rideId, eventId:event, departureTime:time, availableSeats:availableSeats, passengers:passengersInfo)
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
        
        cell.eventName.text = driver.eventId
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.dateFromString(driver.departureTime)
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        cell.departureTime.text = "Departure Time: " + dateFormatter.stringFromDate(date!)
        
        cell.availableSeats.text = String("Available Seats: " + String(driver.availableSeats))
        
//        var spacer: CGFloat = 50
//        for pssngr in driver.passengers {
//            var label = UILabel(frame: CGRectMake(0, 0, 200, 21))
//            label.center = CGPointMake(160, 300 + spacer )
//            label.textAlignment = NSTextAlignment.Center
//            label.text = pssngr.name
//            self.view.addSubview(label)
//            spacer = spacer + 50
//        }
    }
    
    /* Callback for when a cancel button is pressed in a driver cell. Input is the row of the cell at which it's pressed */
    func cancelDriver(row: Int) {
        let titleMsg = "Are you sure?"
        let msg = "Are you sure you want to cancel your ride offering?"
        
        let confirmDialog = UIAlertController(title: titleMsg, message: msg, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Confirm", style: .Default) { (UIAlertAction) -> Void in
            let params = ["ride_id": (self.driverCollection[row].rideId)]
            
            do {
                let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
                
                var dbClient: DBClient!
                dbClient = DBClient()
                dbClient.postData("api/ride/dropRide", body:body)
                
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

        cell.driverName.text = "Driver's Name: " + passenger.driverName
        cell.driverNumber.text = "Driver's Number: " + passenger.driverNumber
        cell.eventName.text = passenger.eventId
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.dateFromString(passenger.departureTime)
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        cell.departureTime.text = "Departure Time: " + dateFormatter.stringFromDate(date!)
    
    }
    
    /* Callback for when a cancel button is pressed in a passenger cell. Input is the row of the cell at which it's pressed */
    func cancelPassenger(row: Int) {
        let titleMsg = "Are you sure?"
        let msg = "Are you sure you want to cancel your spot in the ride?"
        
        let confirmDialog = UIAlertController(title: titleMsg, message: msg, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Confirm", style: .Default) { (UIAlertAction) -> Void in
            let params = ["ride_id": (self.passengerCollection[row].rideId), "passenger_id": (self.passengerCollection[row].passengerId)]
            
            do {
                let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
                var dbClient: DBClient!
                dbClient = DBClient()
                dbClient.postData("api/ride/dropPassenger", body:body)
                
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
    
}
