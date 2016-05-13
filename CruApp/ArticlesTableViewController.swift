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
import DZNEmptyDataSet
import ReachabilitySwift

/* ArticlesTableVC is the screen that holds all articles for user to view */
class ArticlesTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    /* Holds all articles to be displayed */
    var articlesCollection = [Resource]()
    
    /* Called when the current view is loaded */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // A little trick for removing the cell separators
        self.tableView.tableFooterView = UIView()
        
        // Check internet, and if applicable, starts to load the articles
        let internetHelper = InternetHelper()
        
        if (internetHelper.checkInternet(self)) {
            /* Call to database to load articles  */
            DBClient.getData("resources", dict: self.loadArticles)
        }
        else {
            // Sets up the controller to display notification screen if no events populate
            self.tableView.emptyDataSetSource = self;
            self.tableView.emptyDataSetDelegate = self;
            self.tableView.reloadEmptyDataSet()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if (!InternetHelper().checkInternet(self)) {
            // Sets up the controller to display notification screen if no events populate
            self.tableView.emptyDataSetSource = self;
            self.tableView.emptyDataSetDelegate = self;
            self.tableView.reloadEmptyDataSet()
        }
    }
    
    /* Opens a url string in an embedded web browser */
    func showLink(url: String) {
        if let url = NSURL(string: url) {
            let vc = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
            presentViewController(vc, animated: false, completion: nil)
        }
    }

    /* Populates our articles from the Cru database */
    func loadArticles(articles : NSArray) {        
        articlesCollection = [Resource]()
        
        for article in articles {
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
        self.tableView.reloadData()
    
        // Sets up the controller to display notification screen if no articles populate
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.reloadEmptyDataSet()
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
    
    // MARK: - DZNEmptySet Delegate methods
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No articles to display!"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Please check back later."
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }

}
