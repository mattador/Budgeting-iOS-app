//
//  ForecastOverviewTableViewCell.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 13/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController!
            }
        }
        return nil
    }
}

class ForecastOverviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var segmentLabel: UILabel!
    @IBOutlet weak var segmentAmount: UILabel!
    @IBOutlet weak var warningButtonIcon: UIButton!
    
    var messages = [
        "Life account" : "It appears that you have a future financial expense that exceeds your monthly budgets. You might want to consider reducing your monthly spending in order to reach this target, or you won’t be able to afford this expense when the time arrives.",
        "Savings account" : "It appears that you have set a goal that exceeds your monthly budgets. You might want to consider reducing your monthly spending in order to reach this target, or you won’t be able to reach the goal when the time arrives."
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func showWarningAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Warning", message: messages[segmentLabel.text!], preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        parentViewController?.present(alertController, animated: true, completion: nil)
    }
    
}
