//
//  VideosTableViewController.swift
//  CruApp
//
//  Created by Eric Tran on 11/30/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import UIKit
import SwiftLoader
import SwiftSpinner

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
    
    func toString() -> String {
        return "ID: " + self.id! + ", Title: " + self.title! + ", Summary: " + self.summary!
    }
}

/* VideosTableVC is the screen that loads a list of videos and displays them in a table */
class VideosTableViewController: UITableViewController {
    
    /* A reference to the pull-down-to-refresh ui */
    @IBOutlet weak var refresh: UIRefreshControl!
    
    /* Key used to access Google YouTube API. From Google Developer Console */
    var apiKey = "AIzaSyBGaaqJruUGsKohM4PJZO6XnlMOmdt6gsY"
    
    /* Video Channel information */
    var desiredChannelsArray = ["slocrusade"]
    var channelIndex = 0
    var channelsDataArray: Array<Dictionary<NSObject, AnyObject>> = []
    var videosArray: Array<Dictionary<NSObject, AnyObject>> = []
    
    /* Holds a list of videos to be loaded */
    var videos = [Video]()
    
    /* Called when the current view is loaded */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpLoadSpinner()
        self.getChannelDetailsAndLoadVideos(false)
    }
    
    /* Called when the current view appears */
    override func viewDidAppear(animated: Bool) {
        self.setUpRefresh()
    }
    
    /* Sets up and starts the loading indicator */
    func setUpLoadSpinner() {
        SwiftLoader.show(title: "Loading...", animated: true)
        //SwiftSpinner.show("Loading...")
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
    
    /* Populates the list of videos with videos from the Cru Database */
    func loadVideos() {
        self.getVideosForChannelAtIndex(0)
    }
    
    /* Callback method for when user pulls down to refresh */
    func refresh(sender:AnyObject) {
        self.setUpRefresh()
        self.tableView.reloadData()
        self.refresh.endRefreshing()
    }
    
    // MARK: - Table view data source
    
    /* Asks the data source to return the number of sections in the table view. Default is 1. */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    /* Dynamically size the number of rows to match the number of videos we have */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    /* Loads each individual cell in the table with a video */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VideoTableCell", forIndexPath: indexPath) as! VideoTableViewCell
       
        let currentVideo = videos[indexPath.row]
        if (currentVideo.getSummary() == "") {
            cell.setVideoInfo(currentVideo.getId(), title: currentVideo.getTitle(), summary: "No description available")
        } else {
            cell.setVideoInfo(currentVideo.getId(), title: currentVideo.getTitle(), summary: currentVideo.getSummary())
        }
        
        // Make videos a fixed size
        cell.videoPlayer.contentMode = .ScaleAspectFit
        cell.videoPlayer.clipsToBounds = true
        cell.videoPlayer.bounds.size.height = 147
        cell.videoPlayer.bounds.size.width = 122
        
        return cell
    }
    
    /* Callback for when a table cell is selected */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Empty method, can be filled for functionality if needed.
    }

    /* Helper method to perform a simple get request */
    func performGetRequest(targetURL: NSURL!, completion: (data: NSData?, HTTPStatusCode: Int, error: NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: targetURL)
        request.HTTPMethod = "GET"
        
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionConfiguration)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(data: data, HTTPStatusCode: (response as! NSHTTPURLResponse).statusCode, error: error)
            })
        })
        
        task.resume()
    }
    
    /* Retrieves the information about the Cru channel and saves it */
    func getChannelDetailsAndLoadVideos(useChannelIDParam: Bool) -> Void{
        var urlString: String!
        if !useChannelIDParam {
            urlString = "https://www.googleapis.com/youtube/v3/channels?part=contentDetails,snippet&forUsername=\(desiredChannelsArray[channelIndex])&key=\(apiKey)"
        }
        else {
            urlString = "https://www.googleapis.com/youtube/v3/channels?part=contentDetails,snippet&id=\(desiredChannelsArray[channelIndex])&key=\(apiKey)"
        }
        
        let targetURL = NSURL(string: urlString)
        
        performGetRequest(targetURL, completion: { (data, HTTPStatusCode, error) -> Void in
            if HTTPStatusCode == 200 && error == nil {
                
                do {
                    // Convert the JSON data to a dictionary.
                    let resultsDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! Dictionary<NSObject, AnyObject>
                    
                    // Get the first dictionary item from the returned items (usually there's just one item).
                    let items: AnyObject! = resultsDict["items"] as AnyObject!
                    let firstItemDict = (items as! Array<AnyObject>)[0] as! Dictionary<NSObject, AnyObject>
                    
                    // Get the snippet dictionary that contains the desired data.
                    let snippetDict = firstItemDict["snippet"] as! Dictionary<NSObject, AnyObject>
                    
                    // Create a new dictionary to store only the values we care about.
                    var desiredValuesDict: Dictionary<NSObject, AnyObject> = Dictionary<NSObject, AnyObject>()
                    desiredValuesDict["title"] = snippetDict["title"]
                    desiredValuesDict["description"] = snippetDict["description"]
                    desiredValuesDict["thumbnail"] = ((snippetDict["thumbnails"] as! Dictionary<NSObject, AnyObject>)["default"] as! Dictionary<NSObject, AnyObject>)["url"]
                    
                    // Save the channel's uploaded videos playlist ID.
                    desiredValuesDict["playlistID"] = ((firstItemDict["contentDetails"] as! Dictionary<NSObject, AnyObject>)["relatedPlaylists"] as! Dictionary<NSObject, AnyObject>)["uploads"]
                    
                    // Append the desiredValuesDict dictionary to the following array.
                    self.channelsDataArray.append(desiredValuesDict)
                    
                    // Loads the video into the tableview
                    self.loadVideos()
                } catch {
                    print(error)
                }
                
            } else {
                print("HTTP Status Code = \(HTTPStatusCode)")
                print("Error while loading channel details: \(error)")
            }
        })
    }
    
    /* Retrieves the videos for the Cru Channel, and loads it into our table */
    func getVideosForChannelAtIndex(index: Int) -> Void {
        // Get the selected channel's playlistID value from the channelsDataArray array and use it for fetching the proper video playlst.
        
        let playlistID = channelsDataArray[index]["playlistID"] as! String
        
        // Form the request URL string.
        let urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(playlistID)&key=\(apiKey)"
        
        // Create a NSURL object based on the above string.
        let targetURL = NSURL(string: urlString)
        
        // Fetch the playlist from Google.
        performGetRequest(targetURL, completion: { (data, HTTPStatusCode, error) -> Void in
            if HTTPStatusCode == 200 && error == nil {
                do {
                    // Convert the JSON data into a dictionary.
                    let resultsDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! Dictionary<NSObject, AnyObject>
                    
                    // Get all playlist items ("items" array).
                    let items: Array<Dictionary<NSObject, AnyObject>> = resultsDict["items"] as! Array<Dictionary<NSObject, AnyObject>>
                    
                    // Use a loop to go through all video items.
                    for var i=0; i<items.count; ++i {
                        let playlistSnippetDict = (items[i] as Dictionary<NSObject, AnyObject>)["snippet"] as! Dictionary<NSObject, AnyObject>
                        
                        // Initialize a new dictionary and store the data of interest.
                        var desiredPlaylistItemDataDict = Dictionary<NSObject, AnyObject>()
                        
                        desiredPlaylistItemDataDict["title"] = playlistSnippetDict["title"]
                        desiredPlaylistItemDataDict["description"] = playlistSnippetDict["description"]
                        desiredPlaylistItemDataDict["thumbnail"] = ((playlistSnippetDict["thumbnails"] as! Dictionary<NSObject, AnyObject>)["default"] as! Dictionary<NSObject, AnyObject>)["url"]
                        desiredPlaylistItemDataDict["videoID"] = (playlistSnippetDict["resourceId"] as! Dictionary<NSObject, AnyObject>)["videoId"]
                        
                        // Adds the video to our list of videos
                        let newVideo = Video(id: desiredPlaylistItemDataDict["videoID"] as! String, title: desiredPlaylistItemDataDict["title"] as! String, summary: desiredPlaylistItemDataDict["description"] as! String)
                        self.videos.append(newVideo)
                        
                        // Reload the tableview.
                        self.tableView.reloadData()
                        
                        // Finished loading videos, stop the indicator
                        SwiftLoader.hide()
                        //SwiftSpinner.hide()
                    }
                } catch {
                    print(error)
                }
            }
            else {
                print("HTTP Status Code = \(HTTPStatusCode)")
                print("Error while loading channel videos: \(error)")
            }
        })
    }
    
}
