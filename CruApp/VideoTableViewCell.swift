//
//  VideoTableViewCell.swift
//  CruApp
//
//  Created by Eric Tran on 12/1/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class VideoTableViewCell: UITableViewCell {

    @IBOutlet var videoPlayer: YTPlayerView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
