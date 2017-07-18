//
//  BudgetCategoryTableViewCell.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 26/4/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class BudgetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var frequencyOptionField: UIButton!
    @IBOutlet weak var budgetCategoryFieldName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        frequencyOptionField.layer.borderColor = GlobalVariables.borderGrey.cgColor
        amountTextField.keyboardType = UIKeyboardType.decimalPad
        let toolbar: UIToolbar = UIToolbar()
        toolbar.items=[
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(BudgetTableViewCell.doneButtonAction))
        ]
        toolbar.sizeToFit()
        amountTextField.inputAccessoryView = toolbar
    }
    
    func doneButtonAction(){
        amountTextField.endEditing(true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    
}
