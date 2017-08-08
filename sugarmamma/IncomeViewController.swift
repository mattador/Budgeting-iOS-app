//
//  IncomeViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 25/4/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class IncomeViewController: BaseBudgetViewController {
    
    @IBOutlet weak var currencyControl: CurrencyControl!
    
    override var budgetCategoryTitle: String {get{return "Income"}}
    override var sectionHeaders: [String] {get{return ["Salary", "Passive income"]}}
    override var sectionContent: [[BudgetModel]] {get{
        return [
            BudgetManager.fetch("income", entityCategory: "salary"),
            BudgetManager.fetch("income", entityCategory: "passive_income")
        ]
        }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize currency
        currencyControl.selectCurrency(userModel.currency!)
        currencyControl.currencyChanged = {
            currency in
            self.userModel.currency = currency
            self.dataTableView.reloadData()
            self.collectTotals()
            UserManager.persistContext()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsHelper.notifyScreen("Income Budget")
    }
    
    override func hasIncompleteFields() -> Bool{
        if hasIncompleteData(BudgetManager.fetch("income", entityCategory: "salary")) ||
            hasIncompleteData(BudgetManager.fetch("income", entityCategory: "passive_income")){
            return true
        }
        return false
    }
    
    
}
