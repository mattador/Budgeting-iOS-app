//
//  SavingGoalsTableViewCell
//  sugarmamma
//
//  Created by Matthew Cooper on 7/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class SavingGoalsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var goalAmountField: UITextField!
    @IBOutlet weak var goalDateField: UIButton!
    @IBOutlet weak var goalNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        goalDateField.layer.borderColor = GlobalVariables.borderGrey.cgColor
        let toolbar: UIToolbar = UIToolbar()
        toolbar.items=[
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(SavingGoalsTableViewCell.doneButtonAction))
        ]
        toolbar.sizeToFit()
        goalAmountField.inputAccessoryView = toolbar
    }
    
    func doneButtonAction(){
        goalAmountField.endEditing(true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
