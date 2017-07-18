//
//  LoansViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 28/4/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class LoansViewController: BaseBudgetViewController {
    
    override var budgetCategoryTitle: String {get{return "Loans & repayments"}}
    override var sectionHeaders: [String] {get{return ["Loans", "Home expenses"]}}
    override var sectionContent: [[BudgetModel]] {get{
        return [
            BudgetManager.fetch("expense", entityCategory: "loans"),
            BudgetManager.fetch("expense", entityCategory: "home_expenses")
        ]
        }}
    
    override func hasIncompleteFields() -> Bool{
        if hasIncompleteData(BudgetManager.fetch("expense", entityCategory: "loans")) ||
            hasIncompleteData(BudgetManager.fetch("expense", entityCategory: "home_expenses")){
            return true
        }
        return false
    }
}