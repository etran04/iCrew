//
//  ResourcesViewController.swift
//  CruApp
//
//  Created by Eric Tran on 11/30/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import UIKit
// Import Swift module
import YouTubePlayer


class ResourcesViewController: UIViewController {

    @IBOutlet var videoPlayer: YouTubePlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // init YouTubePlayerView w/ playerFrame rect (assume playerFrame declared)
        //var videoPlayer = YouTubePlayerView(frame: playerFrame)
        
        // Load video from YouTube URL
        //let myVideoURL = NSURL(string: "https://www.youtube.com/watch?v=sc0mi0Ei1CQ")
        //videoPlayer.loadVideoURL(myVideoURL!)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
