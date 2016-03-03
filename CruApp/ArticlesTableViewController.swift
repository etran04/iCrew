//
//  ArticlesTableViewController.swift
//  CruApp
//
//  Created by Eric Tran on 12/1/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import UIKit
import SafariServices
import SwiftLoader

///* URLResources is a inner class to hold metadata for a single article or a single tool */
//class URLResources {
//    private var name: String?
//    private var url: String?
//    
//    init(name: String, url: String) {
//        self.name = name
//        self.url = url
//    }
//    
//    func getName() -> String {
//        return self.name!
//    }
//    
//    func getURL() -> String {
//        return self.url!
//    }
//}

/* ArticlesTableVC is the screen that holds all articles for user to view */
class ArticlesTableViewController: UITableViewController {

    /* A reference to the pull-down-to-refresh ui */
    @IBOutlet weak var refresh: UIRefreshControl!
    
    /* A reference to the animated loading spinner */
    var indicator = UIActivityIndicatorView()
    
    /* Holds all articles to be displayed */
    var articlesCollection = [Resource]()
    
    /* Called when the current view is loaded */
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setUpLoadSpinner()
        
        /* Sets up the database */
        var dbClient: DBClient!
        dbClient = DBClient()
        dbClient.getData("resource", dict: loadArticles)
        
        self.tableView.reloadData()
        
    }

    /* Called when the current view appears */
    override func viewDidAppear(animated: Bool) {
        self.setUpRefresh()
        
        /* Sets up the database */
        var dbClient: DBClient!
        dbClient = DBClient()
        dbClient.getData("resource", dict: loadArticles)
        
        self.tableView.reloadData()
        
        //self.loadArticles()
    }
    
    /* Sets up and starts the loading indicator */
    func setUpLoadSpinner() {
        SwiftLoader.show(title: "Loading...", animated: true)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /* Populates our articles from the Cru database */
    func loadArticles(articles : NSArray) {
        //for article in articles {
        
        for article in articles {
            //TODO: need to implement find to grab type=Article
            let type = article["type"] as! String
            if(type == "article") {
                let title = article["title"] as! String
                let url = article["url"] as! String
                let tags = article["tags"] as! [String]
            
                let articleObj = Resource(url : url, type : type, title : title, tags : tags)
                articlesCollection.append(articleObj)
            }
        }
        SwiftLoader.hide()
    }
    
    // MARK: - Table view data source

    /* Asks the data source to return the number of sections in the table view. */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    /* Dynamically size the table according to the number of articles */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesCollection.count
    }
    
    /* Loads each cell in the table with a link */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArticleCell", forIndexPath: indexPath) as! ArticleTableViewCell
        cell.setName(articlesCollection[indexPath.row].title)
        return cell
    }
    
    /* Callback for when a link is clicked */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        showLink(articlesCollection[indexPath.row].url)
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
