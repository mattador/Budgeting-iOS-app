//
//  ForecastSegmentTableViewCell.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 21/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class ForecastSegmentTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryFieldName: UILabel!
    @IBOutlet weak var categoryFieldAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
