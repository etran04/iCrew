//
//  ToolsTableViewController.swift
//  CruApp
//
//  Created by Eric Tran on 2/17/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit
import SafariServices
import SwiftLoader
import DZNEmptyDataSet
import ReachabilitySwift

class ToolsTableViewController: UITableViewController, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    /* A reference to the animated loading spinner */
    var indicator = UIActivityIndicatorView()
    
    /* Holds all tools to be displayed */
    var toolsCollection = [Resource]()
    
    
    /* Called when the current view is loaded */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // A little trick for removing the cell separators
        self.tableView.tableFooterView = UIView()
        
        // Checks internet, and if true, load accordingly
        checkInternet()
    }
    
    /* Called when the current view appears */
    override func viewDidAppear(animated: Bool) {
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
                
                /* Call to database to load articles  */
                DBClient.getData("resources", dict: self.loadTools)
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
    
    /* Populates our articles from the Cru database */
    func loadTools(resources : NSArray) {
        toolsCollection = [Resource]()
        
        for resource in resources {
            let type = resource["type"] as! String
            if(type == "audio") {
                let title = resource["title"] as! String
                let url = resource["url"] as! String
                let tags = resource["tags"] as! [String]
                
                let audioObj = Resource(url : url, type : type, title : title, tags : tags)
                toolsCollection.append(audioObj)
            }
        }
        SwiftLoader.hide()
        self.tableView.reloadData()
        
        // Sets up the controller to display notification screen if no tools populate
        self.tableView.emptyDataSetDelegate = self
        self.tableView.emptyDataSetSource = self
        self.tableView.reloadEmptyDataSet()
    }
    
    /* Opens a url string in an embedded web browser */
    func showLink(url: String) {
        if let url = NSURL(string: url) {
            let vc = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
            presentViewController(vc, animated: false, completion: nil)
        }
    }
    
    /* Populates our articles from the Cru database */
    func loadTools() {
        //#warning to fill in later
    }
    
    // MARK: - Table view data source
    
    /* Asks the data source to return the number of sections in the table view. */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /* Dynamically size the table according to the number of articles */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toolsCollection.count
    }
    
    /* Loads each cell in the table with a link */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ToolCell", forIndexPath: indexPath) as! ToolTableViewCell
        cell.setName(toolsCollection[indexPath.row].title)
        return cell
    }
    
    /* Callback for when a link is clicked */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        showLink(toolsCollection[indexPath.row].url)
    }
    
    /* Callback for when a cell is individually displayed */
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let sectionsAmount = tableView.numberOfSections
        let rowsAmount = tableView.numberOfRowsInSection(indexPath.section)
        if (indexPath.section == sectionsAmount - 1 && indexPath.row == rowsAmount - 1) {
            // This is the last cell in the table, stop the loading indicator
            SwiftLoader.hide()
        }
    }
    
    // MARK: - DZNEmptySet Delegate methods
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No tools to display!"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Please check back later."
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }
}