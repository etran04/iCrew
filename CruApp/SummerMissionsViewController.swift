//
//  SummerMissionsViewController.swift
//  
//
//  Created by Tammy Kong on 12/1/15.
//
//

import UIKit
import DZNEmptyDataSet
import SwiftLoader
import ReachabilitySwift

class SummerMissionsViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    var missionsCollection = [Mission]()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Checks internet, and if internet connectivity is there, load from database
        checkInternet()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if (missionsCollection.isEmpty) {
            checkInternet()
        }
        
        if (self.revealViewController() != nil) {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    /* Determines whether or not the device is connected to WiFi or 4g. Alerts user if they are not.
     * Without internet, data might not populate, aside from cached data */
    func checkInternet() {
        
        // Checks for internet connectivity (Wifi/4G)
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        SwiftLoader.show(title: "Loading...", animated: true)
        
        
        // If device does have internet
        reachability.whenReachable = { reachability in
            dispatch_async(dispatch_get_main_queue()) {
                if reachability.isReachableViaWiFi() {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
                
                // Has internet, load summer missions
                DBClient.getData("summermissions", dict: self.setMissions)
            }
        }
        
        reachability.whenUnreachable = { reachability in
            dispatch_async(dispatch_get_main_queue()) {
                
                // If unreachable, hide the loading indicator anyways
                SwiftLoader.hide()
                
                // If no internet, display an alert notifying user they have no internet connectivity
                let g_alert = UIAlertController(title: "Checking for Internet...", message: "If this dialog appears, please check to make sure you have internet connectivity. ", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    // Dismiss alert dialog
                    print("Dismissed No Internet Dialog")
                }
                g_alert.addAction(OKAction)
                
                // Sets up the controller to display notification screen if no events populate
                self.tableView.emptyDataSetSource = self;
                self.tableView.emptyDataSetDelegate = self;
                self.tableView.reloadEmptyDataSet()
                
                self.presentViewController(g_alert, animated: true, completion: nil)
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    
    //TODO: move it into Mission.swift
    func setMissions(missions:NSArray) -> () {
        
        SwiftLoader.show(title: "Loading...", animated: true)
        
        for mission in missions {
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
        
            if ((mission["image"]??.objectForKey("secure_url") as? String) != nil) {
                image = mission["image"]??.objectForKey("secure_url") as! String
            } else {
                image = ""
            }
        
            //let leaders = nullToNil(mission["leaders"])
            //let image = nullToNil(mission["image"]?.objectForKey("secure_url"))
       
            let location = Location(
                postcode: nullToNil(mission["location"]?!.objectForKey("postcode")),
                state: nullToNil(mission["location"]?!.objectForKey("state")),
                suburb: nullToNil(mission["location"]?!.objectForKey("suburb")),
                street1: nullToNil(mission["location"]?!.objectForKey("street1")),
                country: nullToNil(mission["location"]?!.objectForKey("country")))
        
            var missionObj = Mission(name: name, description: description, image: image, cost: cost, location: location, startDate: startDate, endDate: endDate, url: url, leaders: leaders)
            
            if (image != "") {
                if let data = NSData(contentsOfURL: NSURL(string: image)!) {
                    missionObj.displayingImage = UIImage(data: data)
                }
            }
            
            missionsCollection.append(missionObj)
        }
        SwiftLoader.hide()
        self.tableView.reloadData()
        
        // Sets up the controller to display notification screen if no summer missions to populate
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        
        self.tableView.reloadEmptyDataSet()
    }
    
    func nullToNil(value : AnyObject?) -> String {
        if value is NSNull {
            return ""
        } else {
            return value as! String
        }
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
            
            for view in cell.missionImage.subviews {
                view.removeFromSuperview()
            }
            
            if let image = mission.displayingImage {
                cell.missionImage.image = image
            }
            
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
