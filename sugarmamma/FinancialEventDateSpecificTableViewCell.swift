//
//  FinancialEventDateSpecificTableViewCell.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 27/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class FinancialEventDateSpecificTableViewCell: UITableViewCell {

    @IBOutlet weak var eventAmountField: UITextField!
    @IBOutlet weak var eventNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let toolbar: UIToolbar = UIToolbar()
        toolbar.items=[
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(FinancialEventDateSpecificTableViewCell.doneButtonAction))
        ]
        toolbar.sizeToFit()
        eventAmountField.inputAccessoryView = toolbar
    }
    
    func doneButtonAction(){
        eventAmountField.endEditing(true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
