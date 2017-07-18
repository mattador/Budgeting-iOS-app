//
//  ServicesViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 28/4/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class ServicesViewController: BaseBudgetViewController {
    
    override var budgetCategoryTitle: String {get{return "Services"}}
    override var sectionHeaders: [String] {get{return ["Transport", "Medical", "Education"]}}
    override var sectionContent: [[BudgetModel]] {get{
        return [
            BudgetManager.fetch("expense", entityCategory: "transport"),
            BudgetManager.fetch("expense", entityCategory: "medical"),
            BudgetManager.fetch("expense", entityCategory: "education")
        ]
        }}
    
    override func hasIncompleteFields() -> Bool{
        if hasIncompleteData(BudgetManager.fetch("expense", entityCategory: "transport")) ||
            hasIncompleteData(BudgetManager.fetch("expense", entityCategory: "medical")) ||
            hasIncompleteData(BudgetManager.fetch("expense", entityCategory: "education"))
        {
            return true
        }
        return false
    }
    
}
