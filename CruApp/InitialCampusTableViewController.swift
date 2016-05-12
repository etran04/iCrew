//
//  InitialCampusTableViewController.swift
//  CruApp
//
//  Created by Mariel Sanchez on 1/20/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit
import ReachabilitySwift
import SwiftLoader
import DZNEmptyDataSet

class InitialCampusTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    var campusCollection = [CampusData]()
    var savedCampuses = [CampusData]()
    var selectedIndices: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Checks internet, and if internet connectivity is there, load from database
        checkInternet()
        
        //remove extra separators
        self.tableView.tableFooterView = UIView()
        
        //set empty back button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.nextButton.enabled = false
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
                
                //set up database
                DBClient.getData("campuses", dict: self.setCampuses)
                
                self.savedCampuses = UserProfile.getCampuses()
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
    
    func setCampuses(campuses:NSArray) {
        
        for campus in campuses {
            let name = campus["name"] as! String
            let id = campus["_id"] as! String
        
            campusCollection.append(CampusData(name: name, id: id))
            // TODO: Remove campuses Collection and use cache
        }
        self.tableView.reloadData()
        SwiftLoader.hide()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campusCollection.count //
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! InitialCampusTableViewCell

        //set campus text
        cell.campus.text = campusCollection[indexPath.row].name;
        
        var isSaved = false
        for campus in savedCampuses {
            if campus.name == cell.campus.text {
                isSaved = true
                break
            }
        }
        
        if (isSaved) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            self.nextButton.enabled = true
            selectedIndices.append(indexPath.row)
        }
        
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        let cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if (!selectedIndices.contains(indexPath.row)) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            selectedIndices.append(indexPath.row)
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.None
            selectedIndices.removeAtIndex(selectedIndices.indexOf(indexPath.row)!)
        }
        
        nextButton.enabled = selectedIndices.count > 0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        UserProfile.removeAllEntities("Campus")
        
        for index in selectedIndices {
            UserProfile.addCampus(campusCollection[index])
        }
    }
    
    // MARK: - DZNEmptySet Delegate/DataSource methods
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No campuses to display!"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Please check your internet."
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let str = "Click to refresh!"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        checkInternet()
    }
}
