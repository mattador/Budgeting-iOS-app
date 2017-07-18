//
//  PersonalViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 28/4/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class PersonalViewController: BaseBudgetViewController {
    
    override var budgetCategoryTitle: String {get{return "Personal"}}
    override var sectionHeaders: [String] {get{return ["Personal"]}}
    override var sectionContent: [[BudgetModel]] {get{
        return [
            BudgetManager.fetch("expense", entityCategory: "personal")
        ]
        }}
    
    override func hasIncompleteFields() -> Bool{
        if hasIncompleteData(BudgetManager.fetch("expense", entityCategory: "personal"))
        {
            return true
        }
        return false
    }
    
}
