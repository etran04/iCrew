//
//  VideosTableViewController.swift
//  CruApp
//
//  Created by Eric Tran on 11/30/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import UIKit
import SwiftLoader
import DZNEmptyDataSet
import ReachabilitySwift

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
class VideosTableViewController: UITableViewController, UISearchBarDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    /* A reference to the pull-down-to-refresh ui */
    @IBOutlet weak var refresh: UIRefreshControl!
    /* A reference to the search bar */
    @IBOutlet weak var searchBar: UISearchBar!
    
    /* Key used to access Google YouTube API. From Google Developer Console */
    var apiKey = "AIzaSyBGaaqJruUGsKohM4PJZO6XnlMOmdt6gsY"
    
    /* Video Channel information */
    var desiredChannelsArray = ["slocrusade"]
    var channelIndex = 0
    var channelsDataArray: Array<Dictionary<NSObject, AnyObject>> = []
    var videosArray: Array<Dictionary<NSObject, AnyObject>> = []
    
    /* Holds a list of videos to be loaded */
    var videos = [Video]()
    
    /* Tracks the the next page of videos when fetching from youtube api */
    var nextPageToken = ""
    
    /* Variables used in filtering a search */
    var filtered:[Video] = []
    var filterFor: String?
    var filterFlag = false
    
    /* Called when the current view is loaded */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // checks internet, and then if phone has internet, then start loading videos within
        checkInternet()
    }
    
    /* Called when the current view appears */
    override func viewDidAppear(animated: Bool) {
        searchBar.delegate = self
    }
    
    /* Populates the list of videos with videos from the Cru Database */
    func loadVideos() {
        self.getVideosForChannelAtIndex(0)
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
                self.getChannelDetailsAndLoadVideos(false)
            }
        }
        
        reachability.whenUnreachable = { reachability in
            
            // If unreachable, hide the loading indicator anyways
            SwiftLoader.hide()
            
            dispatch_async(dispatch_get_main_queue()) {
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
       
        cell.summaryTextView.selectable = false
        
        let currentVideo = videos[indexPath.row]
        if (currentVideo.getSummary() == "") {
            cell.setVideoInfo(currentVideo.getId(), title: currentVideo.getTitle(), summary: "No description available")
        } else {
            cell.setVideoInfo(currentVideo.getId(), title: currentVideo.getTitle(), summary: currentVideo.getSummary())
        }
        
        return cell
    }
    
    /* Callback for when a table cell is selected */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Empty method, can be filled for functionality if needed.
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // check if row is last row
        // perform operation to load new cell
        if !self.filterFlag {
            if (indexPath.row == self.videos.count - 1) {
                self.loadVideos()
            }
        }
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
        
        let urlString: String
        var kSearchForAmt = 5
        
        if self.filterFlag {
            self.videos = [Video]()
            kSearchForAmt = 50
        }
        
        // Form the request URL string for first time fetch
        if (nextPageToken == "") {
            urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=\(kSearchForAmt)&playlistId=\(playlistID)&key=\(apiKey)"
        }
        // Or uses the nextPageToken as a user scrolls down the feed 
        else {
             urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&pageToken=\(nextPageToken)&maxResults=\(kSearchForAmt)&playlistId=\(playlistID)&key=\(apiKey)"
        }
        
        // Create a NSURL object based on the above string.
        let targetURL = NSURL(string: urlString)
        
        // Fetch the playlist from Google.
        performGetRequest(targetURL, completion: { (data, HTTPStatusCode, error) -> Void in
            if HTTPStatusCode == 200 && error == nil {
                do {
                    // Convert the JSON data into a dictionary.
                    let resultsDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! Dictionary<NSObject, AnyObject>
                    
                    
                    if resultsDict["nextPageToken"] != nil {
                        // Save the next page token
                        self.nextPageToken = resultsDict["nextPageToken"] as! String
                    } else {
                        return
                    }
                    
                    // Get all playlist items ("items" array).
                    let items: Array<Dictionary<NSObject, AnyObject>> = resultsDict["items"] as! Array<Dictionary<NSObject, AnyObject>>
                    
                    // Use a loop to go through all video items.
                    for var i = 0; i < items.count; ++i {
                        let playlistSnippetDict = (items[i] as Dictionary<NSObject, AnyObject>)["snippet"] as! Dictionary<NSObject, AnyObject>
                        
                        // Initialize a new dictionary and store the data of interest.
                        var desiredPlaylistItemDataDict = Dictionary<NSObject, AnyObject>()
                        
                        desiredPlaylistItemDataDict["title"] = playlistSnippetDict["title"]
                        desiredPlaylistItemDataDict["description"] = playlistSnippetDict["description"]
                        desiredPlaylistItemDataDict["thumbnail"] = ((playlistSnippetDict["thumbnails"] as! Dictionary<NSObject, AnyObject>)["default"] as! Dictionary<NSObject, AnyObject>)["url"]
                        desiredPlaylistItemDataDict["videoID"] = (playlistSnippetDict["resourceId"] as! Dictionary<NSObject, AnyObject>)["videoId"]
                        
                        // Adds the video to our list of videos
                        let newVideo = Video(id: desiredPlaylistItemDataDict["videoID"] as! String, title: desiredPlaylistItemDataDict["title"] as! String, summary: desiredPlaylistItemDataDict["description"] as! String)
                        
                        // If title or summary has a filter keyword, and filter flag is on, filter the videos accordingly
                        let titleHolder = desiredPlaylistItemDataDict["title"] as! String
                        let summaryHolder = desiredPlaylistItemDataDict["description"] as! String
                        if self.filterFlag {
                            if titleHolder.containsString(self.filterFor!) || summaryHolder.containsString(self.filterFor!) {
                                self.videos.append(newVideo)
                            }
                        }
                        else {
                            self.videos.append(newVideo)
                        }
                    }
                    
                    // Get the last index of videos 
                    let lastNdx = self.videos.count
                    var startReloadNdx = 0
                    if (lastNdx > 5) {
                        startReloadNdx = lastNdx - 5
                    }
                    
                    // Create indexPaths starting from startReloadNdx to end 
                    var rowArr = [NSIndexPath]()
                    for var i = startReloadNdx; i < lastNdx; i++ {
                        let indexPath = NSIndexPath(forRow: i, inSection: 0)
                        rowArr.append(indexPath)
                    }
                    
                    // Reload the tableview.
                    self.tableView.beginUpdates()
                    self.tableView.insertRowsAtIndexPaths(rowArr, withRowAnimation: UITableViewRowAnimation.Automatic)
                    self.tableView.endUpdates()
                    
                    // Finished loading videos, stop the indicator
                    SwiftLoader.hide()
                    
                    // Sets up the controller to display notification screen if no articles populate
                    self.tableView.emptyDataSetSource = self
                    self.tableView.emptyDataSetDelegate = self
                    self.tableView.reloadEmptyDataSet()
                    
                    
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
    
    // MARK : - UISearchbarDelegate methods
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.filterFor = searchBar.text
        self.nextPageToken = ""
        self.filterFlag = true
        self.getVideosForChannelAtIndex(0)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("cancel pressed")
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "") {
            self.videos = [Video]()
            self.nextPageToken = ""
            self.filterFlag = false
            self.getVideosForChannelAtIndex(0)
        }
    }
    
    // MARK: - DZNEmptySet Delegate methods
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No videos to display!"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Please check back later."
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
}
