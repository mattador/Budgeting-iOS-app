//
//  TipsPlaylistTableViewCell.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 7/8/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit
import YouTubePlayer

class TipsPlaylistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tipsPlaylistTitle: UILabel!
    @IBOutlet var youtubePlayer: YouTubePlayerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
