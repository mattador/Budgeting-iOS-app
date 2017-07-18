//
//  ForecastSegmentGoalsTableViewCell.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 12/6/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class ForecastSegmentGoalsTableViewCell: UITableViewCell {

    @IBOutlet weak var goalName: UILabel!
    @IBOutlet weak var goalProgressBar: UIProgressView!
    @IBOutlet weak var goalAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
