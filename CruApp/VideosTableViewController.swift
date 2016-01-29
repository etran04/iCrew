//
//  VideosTableViewController.swift
//  CruApp
//
//  Created by Eric Tran on 11/30/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import UIKit

/* Video represents a holder for metadata of a single individual youtube video */
class Video {
    private var id: String?
    private var title: String?
    private var summary: String?
    
    init(id: String, title: String, summary: String) {
        self.id = id
        self.title = title
        self.summary = summary
    }
    
    func getId() -> String {
        return self.id!
    }
    
    func getTitle() -> String {
        return self.title!
    }
    
    func getSummary() -> String {
        return self.summary!
    }
}

/* VideosTableVC is the screen that loads a list of videos and displays them in a table */
class VideosTableViewController: UITableViewController {
    
    /* Holds a list of videos to be loaded */
    var videos = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadVideos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /* Populates the list of videos with videos from the Cru Database */
    func loadVideos() {
        self.videos += [
            Video(id: "9cmh72Z9ISI", title: "chinchilla massage", summary: "Kimchi just loves her scratches"),
            Video(id: "FNf-IGmxElI", title: "Tiny hamster eatting a tiny pizza", summary: "Inspired by tiny hamster eating tiny burrito, here is Chicken eating a tiny pizza. She is my one year old, russian dwarf hamster. I got her at the Petsmart in Ottawa, ON. She's my first hamster. She is super sweet and the best hamster anyone could ever wish for."),
            Video(id: "BIHVxynRvDk", title: "Samoyed puppies (37 Days old) - 'manners'", summary: "Six Samoyed puppies born March 31, 2012. More info at www.SamoyedMoms.com and www.PotomacValleySams.com - home of the Potomac Valley Samoyed Club of Washington, D.C., Virginia, Maryland and West Virginia"),
            Video(id: "-n4XX5nnXhU", title: "ROCKY the French Bulldog puppy jumping", summary: "For licensing/usage please contact: licensing(at)jukinmediadotcom")
        ]
    }
    
    // MARK: - Table view data source
    
    /* Asks the data source to return the number of sections in the table view. Default is 1. */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /* Dynamically size the number of rows to match the number of videos we have */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    /* Loads each individual cell in the table with a video */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VideoTableCell", forIndexPath: indexPath) as! VideoTableViewCell
       
        let currentVideo = videos[indexPath.row]
        cell.setVideoInfo(currentVideo.getId(), title: currentVideo.getTitle(), summary: currentVideo.getSummary())
        
        // Make videos a fixed size
        cell.videoPlayer.contentMode = .ScaleAspectFit
        cell.videoPlayer.clipsToBounds = true
        cell.videoPlayer.bounds.size.height = 147
        cell.videoPlayer.bounds.size.width = 122
        
        return cell
    }
    
    /* Callback for when a table cell is selected */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
