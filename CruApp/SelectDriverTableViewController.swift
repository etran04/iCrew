//
//  SelectDriverTableViewController.swift
//  CruApp
//
//  Created by Tammy Kong on 2/18/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class SelectDriverTableViewController: UITableViewController {
    var passenger : Passenger!
    var driverCollection = [Driver]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        var dbClient: DBClient!
        dbClient = DBClient()
        dbClient.getData("ride", dict: setDrivers)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDrivers(drivers:NSArray) {
        
        for driver in drivers {
            
        
            let eventId = driver["event"] as! String
            let availableSeats = (driver["seats"] as! Int) - (driver["passengers"]!!.count) as Int
            let time = driver["time"] as! String
            var direction = ""
        
            if(driver["direction"] != nil) {
                direction = driver["direction"] as! String
            }
        
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let driverTime = dateFormatter.dateFromString(time)
        
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z'"
            let passengerTime = dateFormatter.dateFromString(passenger.time)

            if (passenger.eventId == eventId
                && availableSeats != 0
                && driverTime!.compare(passengerTime!) == NSComparisonResult.OrderedAscending
                && direction == passenger.direction) {
                    print("yay")
                    let id = driver["_id"] as! String
                    let name = driver["driverName"] as! String
                    let driverNumber = driver["driverNumber"] as! String
            
                    let driverObj = Driver(id: id, name: name, number : driverNumber, eventId: eventId, departureTime: time)
            
                    driverCollection.append(driverObj)
            }
        }
        self.tableView.reloadData()
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return driverCollection.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("SelectRideCell", forIndexPath: indexPath) as! SelectDriverTableViewCell
        let driver = driverCollection[indexPath.row]
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.dateFromString(driver.departureTime)
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        let dateString = dateFormatter.stringFromDate(date!)
        
        cell.driverName.text = "Name: " + driver.name
        cell.driverNumber.text = "Phone Number: " + driver.number
        cell.depatureTime.text = "Departure Time: " + dateString

        return cell
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let selectedDriverViewController = segue.destinationViewController as! DriverSelectedViewController
        if let selectedDriverCell = sender as? SelectDriverTableViewCell {
            let indexPath = tableView.indexPathForCell(selectedDriverCell)!
            let selectedDriver = driverCollection[indexPath.row]
            
            let params =
            [
                "name": passenger.name,
                "direction": passenger.direction,
                "phone": passenger.phoneNumber,
                "gcm_id" : 1234567
            ]
            
            do {
                let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
                var dbClient: DBClient!
                dbClient = DBClient()
                dbClient.addPassenger(selectedDriver.id, action: "passenger", body : body)
            } catch {
                print("Error sending data to database")
            }
            
            
            selectedDriverViewController.driver = selectedDriver
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
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
