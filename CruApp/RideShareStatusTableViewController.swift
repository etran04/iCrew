//
//  RideShareStatusTableViewController.swift
//  CruApp
//
//  Created by Tammy Kong on 2/25/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

let kDriverHeader = "You will be a driver for..."
let kPassengerHeader = "You will be a passenger for..."

class RideShareStatusTableViewController: UITableViewController {
    
    /* Header titles, can be changed if needed */
    let headerTitles = [kDriverHeader, kPassengerHeader]
    
    /* Arrays used to hold each section of user's rideshare data */
    var driverCollection = [Driver]()
    var passengerCollection = [Passenger]()
    
    var tableData = [[AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Replaces the extra cells at the end with a clear view
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchStatuses() {
        driverCollection = [Driver]()
        passengerCollection = [Passenger]()
        
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tableData.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
                cell = tableView.dequeueReusableCellWithIdentifier("Passenger", forIndexPath: indexPath)
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
        
//        let imagePath = "http://graph.facebook.com/\(order.ownerId!)/picture?type=large"
//        self.downloadImage(NSURL(string: imagePath)!, picture: cell.picture)
//        
//        cell.locationLabel.text = order.location
//        cell.estimateCostLabel.text = order.estimate
//        
//        let formatter = NSDateFormatter()
//        formatter.timeStyle = .ShortStyle
//        
//        let startTime = formatter.stringFromDate(order.startTime!)
//        let endTime = formatter.stringFromDate(order.endTime!)
//        cell.availableTimeFrameLabel.text = "Available time: " + startTime + " – " + endTime
    }
    
    /* Helper function for filling in pending cell with its information */
    func populatePassengerCell(indexPath: NSIndexPath, cell: PassengerStatusTableViewCell) {
        
        let passenger = passengerCollection[indexPath.row]
        
//        let imagePath = "http://graph.facebook.com/\(order.ownerId!)/picture?type=large"
//        self.downloadImage(NSURL(string: imagePath)!, picture: cell.picture)
//        
//        cell.locationLabel.text = order.location
//        cell.estimateCostLabel.text = order.estimate
//        
//        let formatter = NSDateFormatter()
//        formatter.timeStyle = .ShortStyle
//        
//        let startTime = formatter.stringFromDate(order.startTime!)
//        let endTime = formatter.stringFromDate(order.endTime!)
//        cell.availableTimeFrameLabel.text = "Available time: " + startTime + " – " + endTime
    }
    
    
//    func cancelPendingTransaction(row: Int) {
//        
//        let confirmDialog = UIAlertController(title: "Are you sure?", message: "Are you sure you want to cancel your current request?", preferredStyle: .Alert)
//        let okAction = UIAlertAction(title: "Confirm", style: .Default) { (UIAlertAction) -> Void in
//            
//            // removes order from firebase and then the table
//            FirebaseClient.removeOrder(self.pendingOrders[row].id)
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
