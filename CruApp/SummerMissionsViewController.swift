//
//  SummerMissionsViewController.swift
//  
//
//  Created by Tammy Kong on 12/1/15.
//
//

import UIKit
import DZNEmptyDataSet

class SummerMissionsViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    var missionsCollection = [Mission]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up the controller to display notification screen if no events populate
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        
        var dbClient:DBClient!
        dbClient = DBClient()
        dbClient.getData("summermission", dict: setMissions)
    }
    
    //TODO: move it into Mission.swift
    func setMissions(mission:NSDictionary) -> () {
        var url: String
        var leaders: String
        var image: String
        
        let name = nullToNil(mission["name"])
        let description = nullToNil(mission["description"])
        let startDate = nullToNil(mission["startDate"])
        let endDate = nullToNil(mission["endDate"])
        let cost = mission["cost"] as! Int
        if ((mission["url"] as? String) != nil) {
            url = mission["url"] as! String
        } else {
            url = ""
        }
        
        if ((mission["leaders"] as? String) != nil) {
            leaders = mission["leaders"] as! String
        } else {
            leaders = "N/A"
        }
        
        if ((mission["image"]?.objectForKey("secure_url") as? String) != nil) {
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
            cell.missionDate.text = dateFormatter.stringFromDate(startDate!) + " – " + dateFormatter.stringFromDate(endDate!)
            
            return cell
    }

    
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
    
    // MARK: - DZNEmptySet Delegate methods
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No summer missions to display!"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Please check back later or add more ministries."
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    //    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
    //        return UIImage(named: "taylor-swift")
    //    }
    
    //    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
    //        let str = "Placeholder for a button"
    //        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)]
    //        return NSAttributedString(string: str, attributes: attrs)
    //    }
    //
    //    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
    //        let ac = UIAlertController(title: "Button tapped!", message: nil, preferredStyle: .Alert)
    //        ac.addAction(UIAlertAction(title: "Hurray", style: .Default, handler: nil))
    //        presentViewController(ac, animated: true, completion: nil)
    //    }

}
