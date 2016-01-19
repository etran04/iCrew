//
//  SummerMissionsViewController.swift
//  
//
//  Created by Tammy Kong on 12/1/15.
//
//

import UIKit

class SummerMissionsViewController: UITableViewController {

    var missionsCollection = [Mission]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        var dbClient:DBClient!
        dbClient = DBClient()
        dbClient.getData("summermission", dict: setEvents)
    }
    
    func setEvents(mission:NSDictionary) -> () {
        let name = mission["name"] as! String
        let description = mission["description"] as! String
        let startDate = mission["startDate"] as! String
        let endDate = mission["endDate"] as! String
        let cost = mission["cost"] as! Int
        let url = mission["url"] as! String
        let leaders = mission["leaders"] as! [String]
        let image = mission["image"]?.objectForKey("secure_url") as! String!
        
        let location = Location(
            postcode: mission["location"]?.objectForKey("postcode") as! String,
            state: mission["location"]?.objectForKey("state") as! String,
            suburb: mission["location"]?.objectForKey("suburb") as! String,
            street1: mission["location"]?.objectForKey("street1") as! String,
            country: mission["location"]?.objectForKey("country") as! String)
        
        let missionObj = Mission(name: name, description: description, image: image, cost: cost, location: location, startDate: startDate, endDate: endDate, url: url, leaders: leaders)
        
        missionsCollection.append(missionObj)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missionsCollection.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("MissionCell", forIndexPath: indexPath)
            
            let mission = missionsCollection[indexPath.row]
            cell.textLabel?.text = mission.name
            //cell.detailTextLabel?.text = mission.description
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
