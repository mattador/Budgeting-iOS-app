//
//  TipsTableViewCell.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 27/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class TipsTableViewCell: UITableViewCell {

    @IBOutlet weak var TipsVIdeo: UIWebView!
    @IBOutlet weak var TipsLabel: UILabel!
    @IBOutlet weak var TipsDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
