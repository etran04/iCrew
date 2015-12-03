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
    var videoId: String?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        print(videoId)
//        self.videoPlayer.loadWithVideoId(videoId)
//        self.videoPlayer.loadWithVideoId("9cmh72Z9ISI")

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        print(videoId)

       self.videoPlayer.loadWithVideoId("9cmh72Z9ISI")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setVideoInfo(id: String) {
        self.videoId = id
    }
    
}
