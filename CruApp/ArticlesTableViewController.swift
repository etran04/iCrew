//
//  ArticlesTableViewController.swift
//  CruApp
//
//  Created by Eric Tran on 12/1/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import UIKit
import SafariServices

class Article {
    private var name: String?
    private var url: String?
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
    
    func getName() -> String {
        return self.name!
    }
    
    func getURL() -> String {
        return self.url!
    }
}

class ArticlesTableViewController: UITableViewController {

    var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadArticles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showLink(url: String) {
        if let url = NSURL(string: url) {
            let vc = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
            presentViewController(vc, animated: false, completion: nil)
        }
    }

    func loadArticles() {
        self.articles += [
            Article(name: "Discerning God's Will",
                    url: "http://www.slocru.com/assets/resources/pdf/Discerning_Gods_Will_by_Youth_Specialties.pdf"),
            Article(name: "Biblical Career Principals",
                    url: "http://www.slocru.com/assets/resources/pdf/Biblical_Career_Principals_By_Navigator.pdf")
        ]
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArticleTableViewCell", forIndexPath: indexPath) as! ArticleTableViewCell

        // Configure the cell...
        cell.setArticleInfo(articles[indexPath.row].getName())
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        showLink(articles[indexPath.row].getURL())
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
