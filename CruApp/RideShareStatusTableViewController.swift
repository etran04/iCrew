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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Replaces the extra cells at the end with a clear view
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Gets the orders from Firebase
        self.fetchStatuses()
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
                    
                        print("user is a passenger")
                        if(gcm_id == data.gcmId) {
                            let passengerObj = RideSharePassenger(rideId:rideId, passengerId:pssngr, eventId:event, departureTime:time, driverNumber:driverNumber, driverName:driverName)
                            passengerCollection.append(passengerObj)
                        }
                    }
                }
            }
        
            //if user is a driver
            if(gcm_id == gcmId) {
                print("user is a driver")
                let rideObj = RideShareDriver(rideId:rideId, eventId:event, departureTime:time, availableSeats:availableSeats, passengers:passengersInfo)
                driverCollection.append(rideObj)
            }
        }
        
        // array to hold all status by section
        self.tableData = [self.driverCollection, self.passengerCollection]
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print("table section: \(tableData.count)")

        return tableData.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("table rows: \(tableData[section].count)")
        return tableData[section].count
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
                cell = tableView.dequeueReusableCellWithIdentifier("DriverCell", forIndexPath: indexPath)
                populateDriverCell(indexPath, cell: (cell as! DriverStatusTableViewCell))
                break
            case kPassengerHeader:
                cell = tableView.dequeueReusableCellWithIdentifier("PassengerCell", forIndexPath: indexPath)
                populatePassengerCell(indexPath, cell: (cell as! PassengerStatusTableViewCell))
                break
            default:
                break
        }
        
        return cell
    }
    
    /* Helper function for filling in pending cell with its information */
    func populateDriverCell(indexPath: NSIndexPath, cell: DriverStatusTableViewCell) {
        
        let driver = driverCollection[indexPath.row]
        
        cell.eventName.text = driver.eventId
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.dateFromString(driver.departureTime)
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        cell.departureTime.text = "Departure Time: " + dateFormatter.stringFromDate(date!)
        
        cell.availableSeats.text = String(driver.availableSeats)
        
//        var spacer: CGFloat = 50
//        for pssngr in driver.passengers {
//            var label = UILabel(frame: CGRectMake(0, 0, 200, 21))
//            label.center = CGPointMake(160, 300 + spacer )
//            label.textAlignment = NSTextAlignment.Center
//            label.text = pssngr.name
//            self.view.addSubview(label)
//            spacer = spacer + 50
//        }
        
        cell.cancelDriver.addTarget(self, action: "cancelDriver:", forControlEvents: .TouchUpInside)
        cell.cancelDriver.tag = indexPath.row
    }
    
    func cancelDriver(sender: UIButton) {
        let buttonTag = sender.tag
        
        let params = ["ride_id": (driverCollection[buttonTag].rideId)]
        
        do {
            let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            
            var dbClient: DBClient!
            dbClient = DBClient()
            dbClient.postData("api/ride/dropRide", body:body)
            
        } catch {
            print("Error sending data to database")
        }
    }
    
    /* Helper function for filling in pending cell with its information */
    func populatePassengerCell(indexPath: NSIndexPath, cell: PassengerStatusTableViewCell) {
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
    
        cell.cancelButton.addTarget(self, action: "cancelPassenger:", forControlEvents: .TouchUpInside)
        cell.cancelButton.tag = indexPath.row
    }
    
    func cancelPassenger(sender: UIButton) {
        let buttonTag = sender.tag
        
        let params = ["ride_id": (passengerCollection[buttonTag].rideId), "passenger_id": (passengerCollection[buttonTag].passengerId)]
        
        do {
            let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            var dbClient: DBClient!
            dbClient = DBClient()
            dbClient.postData("api/ride/dropPassenger", body:body)
            
        } catch {
            print("Error sending data to database")
        }
    }
    
    
//    func cancelPendingTransaction(row: Int) {
//        let confirmDialog = UIAlertController(title: "Are you sure?", message: "Are you sure you want to cancel your ride?", preferredStyle: .Alert)
//        let okAction = UIAlertAction(title: "Confirm", style: .Default) { (UIAlertAction) -> Void in
//            
//            // removes order from firebase and then the table
//            DBClient.postData(self.pendingOrders[row].id)
//            
//            self.pendingOrders.removeAtIndex(row)
//            
//            // array to hold all orders by section
//            self.tableData = [self.pendingOrders, self.progressOrders, self.completedOrders]
//            self.tableView.reloadData()
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//        
//        confirmDialog.addAction(okAction)
//        confirmDialog.addAction(cancelAction)
//        
//        self.presentViewController(confirmDialog, animated: true, completion: nil)
//    }
    

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
