//
//  DashboardBudgetManagerViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 28/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class DashboardBudgetManagerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var budgetManagerTable: UITableView!
    
    var budgetCategories = [
        "Income", "Loans & repayments", "Services", "Personal", "Goals"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsHelper.notifyScreen("Dashboard Budget Manager")
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return budgetCategories.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellIdentifier = "BudgetManagerTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BudgetManagerTableViewCell
        cell.budgetCategoryTitle.text = budgetCategories[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.budgetManagerTable.indexPathForSelectedRow {
            if let controller = segue.destination as? DashboardBudgetManagerDetailViewController{
                controller.budgetCategory = budgetCategories[indexPath.row]
            }
        }
    }
    
}
