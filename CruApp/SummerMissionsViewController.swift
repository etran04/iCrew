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
        dbClient.getData("summermission", dict: setMissions)
    }
    
    func setMissions(mission:NSDictionary) -> () {
        var url: String
        var leaders: String
        var image: String
        
        let name = nullToNil(mission["name"])
        let description = nullToNil(mission["description"])
        let startDate = nullToNil(mission["startDate"])
        let endDate = nullToNil(mission["endDate"])
        let cost = mission["cost"] as! Int
        if let value: String = mission["url"] as? String {
            url = mission["url"] as! String
        } else {
            url = ""
        }
        
        if let value: String = mission["leaders"] as? String {
            leaders = mission["leaders"] as! String
        } else {
            leaders = "N/A"
        }
        
        if let value: String = mission["image"]?.objectForKey("secure_url") as? String {
            image = mission["image"]?.objectForKey("secure_url") as! String
        } else {
            image = ""
        }
        
        //let leaders = nullToNil(mission["leaders"])
        //let image = nullToNil(mission["image"]?.objectForKey("secure_url"))
       
        let location = Location(
            postcode: nullToNil(mission["location"]?.objectForKey("postcode")),
            state: nullToNil(mission["location"]?.objectForKey("state")),
            suburb: nullToNil(mission["location"]?.objectForKey("suburb")),
            street1: nullToNil(mission["location"]?.objectForKey("street1")),
            country: nullToNil(mission["location"]?.objectForKey("country")))
        
        let missionObj = Mission(name: name, description: description, image: image, cost: cost, location: location, startDate: startDate, endDate: endDate, url: url, leaders: leaders)

        missionsCollection.append(missionObj)
        self.tableView.reloadData()
    }
    
    func nullToNil(value : AnyObject?) -> String {
        if value is NSNull {
            return ""
        } else {
            return value as! String
        }
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
            
            let cell = tableView.dequeueReusableCellWithIdentifier("MissionCell", forIndexPath: indexPath) as! MissionViewCell
            
            let mission = missionsCollection[indexPath.row]
            cell.missionTitle.text = mission.name
            
            
            //date formatting
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let startDate = dateFormatter.dateFromString(mission.startDate!)
            let endDate = dateFormatter.dateFromString(mission.endDate!)
            dateFormatter.dateFormat = "MM/dd/YY"
            cell.missionDate.text = dateFormatter.stringFromDate(startDate!) + " - " + dateFormatter.stringFromDate(endDate!)
            
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let missionDetailViewController = segue.destinationViewController as! MissionDetailsViewController
        if let selectedMissionCell = sender as? MissionViewCell {
            let indexPath = tableView.indexPathForCell(selectedMissionCell)!
            let selectedMission = missionsCollection[indexPath.row]
            missionDetailViewController.mission = selectedMission
        }
    }
    

}
