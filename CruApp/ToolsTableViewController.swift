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

class ToolsTableViewController: UITableViewController {
    
    /* A reference to the pull-down-to-refresh ui */
    @IBOutlet weak var refresh: UIRefreshControl!
    
    /* A reference to the animated loading spinner */
    var indicator = UIActivityIndicatorView()
    
    /* Holds all tools to be displayed */
    var toolsCollection = [Resource]()
    
    
    /* Called when the current view is loaded */
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setUpLoadSpinner()
        
        /* Sets up the database */
        DBClient.getData("resource", dict: loadArticles)
        
        self.tableView.reloadData()
        
        //self.loadTools()
    }
    
    /* Called when the current view appears */
    override func viewDidAppear(animated: Bool) {
        
        self.setUpRefresh()
    }
    
    /* Sets up and starts the loading indicator */
    func setUpLoadSpinner() {
        SwiftLoader.show(title: "Loading...", animated: true)
    }
    
    /* Populates our articles from the Cru database */
    func loadArticles(resources : NSArray) {
        //for article in articles {
        
        for resource in resources {
            //TODO: need to implement find to grab type=Article
            let type = resource["type"] as! String
            if(type == "audio") {
                let title = resource["title"] as! String
                let url = resource["url"] as! String
                let tags = resource["tags"] as! [String]
                
                let audioObj = Resource(url : url, type : type, title : title, tags : tags)
                toolsCollection.append(audioObj)
            }
        }
        self.tableView.reloadData()
        SwiftLoader.hide()
    }
    
    /* Resets the refresh UI control */
    func setUpRefresh() {
        // Update the displayed "Last update: " time in the UIRefreshControl
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        let updateString = "Last updated: " + formatter.stringFromDate(date)
        self.refresh.attributedTitle = NSAttributedString(string: updateString)
        
        /* Set the callback for when pulled down */
        self.refresh.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    /* Callback method for when user pulls down to refresh */
    func refresh(sender:AnyObject) {
        self.setUpRefresh()
        self.tableView.reloadData()
        self.refresh.endRefreshing()
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
}