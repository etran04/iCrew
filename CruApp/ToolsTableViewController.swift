//
//  ToolsTableViewController.swift
//  CruApp
//
//  Created by Eric Tran on 2/17/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit
import SafariServices

class ToolsTableViewController: UITableViewController {
    
    /* A reference to the pull-down-to-refresh ui */
    @IBOutlet weak var refresh: UIRefreshControl!
    
    /* A reference to the animated loading spinner */
    var indicator = UIActivityIndicatorView()
    
    /* Holds all tools to be displayed */
    var tools = [URLResources]()
    
    /* Called when the current view is loaded */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpLoadSpinner()
        self.loadTools()
    }
    
    /* Called when the current view appears */
    override func viewDidAppear(animated: Bool) {
        self.setUpRefresh()
    }
    
    /* Sets up and starts the loading indicator */
    func setUpLoadSpinner() {
        indicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        indicator.center = self.view.center
        
        /* scales the indicator to twice the color */
        let transform = CGAffineTransformMakeScale(2, 2)
        indicator.transform = transform;
        
        self.view.addSubview(indicator)
        //indicator.startAnimating()
    }
    
    /* Resets the refresh UI control */
    func setUpRefresh() {
        // Update the displayed "Last update: " time in the UIRefreshControl
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.timeStyle = .MediumStyle
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
        return tools.count
    }
    
    /* Loads each cell in the table with a link */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ToolCell", forIndexPath: indexPath) as! ToolTableViewCell
        cell.setName(tools[indexPath.row].getName())
        return cell
    }
    
    /* Callback for when a link is clicked */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        showLink(tools[indexPath.row].getURL())
    }
    
    /* Callback for when a cell is individually displayed */
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let sectionsAmount = tableView.numberOfSections
        let rowsAmount = tableView.numberOfRowsInSection(indexPath.section)
        if (indexPath.section == sectionsAmount - 1 && indexPath.row == rowsAmount - 1) {
            // This is the last cell in the table, stop the loading indicator
            self.indicator.stopAnimating()
        }
    }
}