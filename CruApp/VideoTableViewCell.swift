//
//  VideoTableViewCell.swift
//  CruApp
//
//  Created by Eric Tran on 12/1/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

/* VideoTableViewCell is a representation of a single cell in our table view controller. 
 * It contains video information that will populate and display the video in the cell */ 
class VideoTableViewCell: UITableViewCell {

    @IBOutlet var videoPlayer: YTPlayerView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        videoTitle.font = UIFont(name: "FreightSansProBold-Regular", size: 17.0)
        summaryTextView.font = UIFont(name: "FreightSansProMedium-Regular", size: 14.0)
        summaryTextView.textContainer.lineBreakMode = .ByWordWrapping
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setVideoInfo(id: String, title: String, summary: String) {
        self.videoPlayer.loadWithVideoId(id)
        self.videoTitle.text = title
        self.summaryTextView.text = summary
    }
    
}
