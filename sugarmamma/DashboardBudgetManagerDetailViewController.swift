//
//  DashboardBudgetManagerDetailViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 28/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class DashboardBudgetManagerDetailViewController: BaseSetupControllerViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var dataTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var budgetAddButton: UIButton!
    
    var budgetCategory: String = ""
    var budgetSectionHeaders: [String] = []
    var budgetSectionContent: [[NSObject]] = []
    var justLoaded: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        justLoaded = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !justLoaded{
            reloadData()
        }else{
            justLoaded = false
        }
    }
    
    func reloadData(){
        titleLabel.text = budgetCategory
        switch budgetCategory {
        case "Income":
            budgetSectionHeaders = ["Salary", "Passive income"]
            budgetSectionContent = [
                BudgetManager.fetch("income", entityCategory: "salary"),
                BudgetManager.fetch("income", entityCategory: "passive_income")
            ]
            break
        case "Loans & repayments":
            budgetSectionHeaders = ["Loans", "Home expenses"]
            budgetSectionContent =  [
                BudgetManager.fetch("expense", entityCategory: "loans"),
                BudgetManager.fetch("expense", entityCategory: "home_expenses")
            ]
            break
        case "Services":
            budgetSectionHeaders = ["Transport", "Medical", "Education"]
            budgetSectionContent = [
                BudgetManager.fetch("expense", entityCategory: "transport"),
                BudgetManager.fetch("expense", entityCategory: "medical"),
                BudgetManager.fetch("expense", entityCategory: "education")
            ]
            break
        case "Personal":
            budgetSectionHeaders = ["Personal"]
            budgetSectionContent = [
                BudgetManager.fetch("expense", entityCategory: "personal"),
                BudgetManager.fetch("expense", entityCategory: "other_personal")
            ]
            break
        case "Goals":
            budgetSectionHeaders = [""]
            budgetSectionContent = [
                SavingGoalsManager.fetch()
            ]
            break
        default:
            break
        }
        collectTotals()
        dataTableView.reloadData()
        disableAddButtonObserver()
    }
    
    func disableAddButtonObserver(){
        if budgetCategory == "Goals"{
            //if there > 0 goals exist disable add goal button (business rule: you should only be able to have one savings goal at a time otherwise calculations for the savings account will become too complex)
            if budgetSectionContent[0].count > 0{
                budgetAddButton.layer.backgroundColor = GlobalVariables.lightTextGrey.cgColor
                budgetAddButton.setTitleColor(UIColor.white, for: .normal)
                budgetAddButton.isEnabled = false
            }else{
                budgetAddButton.layer.backgroundColor = GlobalVariables.strongYellow.cgColor
                budgetAddButton.setTitleColor(GlobalVariables.buttonTextGrey, for: .normal)
                budgetAddButton.isEnabled = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return budgetSectionHeaders[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return budgetSectionHeaders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budgetSectionContent[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //satisfy strict typing
        if budgetCategory != "Goals"{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetCell", for: indexPath) as! BudgetTableViewCell
            cell.amountTextField.delegate = self
            
            let cellContent = budgetSectionContent[indexPath.section][indexPath.row] as! BudgetModel
            
            //restore store values
            if(cellContent.amount > 0){
                cell.amountTextField.text = String(format: "%.2f", cellContent.amount)
            }else{
                cell.amountTextField.text = ""
            }
            
            if let frequency = cellContent.frequency{
                cell.frequencyOptionField.setTitle(frequency, for: .normal)
                cell.frequencyOptionField.backgroundColor = GlobalVariables.pastelGreen
            }else{
                if cellContent.amount > 0{
                    cell.frequencyOptionField.backgroundColor = GlobalVariables.pinkRed
                }else{
                    cell.frequencyOptionField.backgroundColor = GlobalVariables.purple
                }
                
                cell.frequencyOptionField.setTitle("Frequency", for: .normal)
            }
            cell.budgetCategoryFieldName.text = cellContent.label
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SavingGoalsTableViewCell", for: indexPath) as! SavingGoalsTableViewCell
            cell.goalAmountField.delegate = self
            //cell.eventDateField.delegate = self
            let cellContent = budgetSectionContent[indexPath.section][indexPath.row] as! SavingGoalsModel
            //restore store values
            if cellContent.amount > 0{
                cell.goalAmountField.text = String(format: "%.2f", cellContent.amount)
            }
            cell.goalNameLabel.text = cellContent.goal_name
            cell.goalDateField.setTitle(DateHelper.toString(cellContent.goal_due_date! as Date, dateFormat: "d/M/yyyy"), for: .normal)
            return cell
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        self.view.endEditing(true)
        return true
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView, let textLabel = headerView.textLabel {
            //headerView.layer.top/
            let newSize = CGFloat(17)
            let fontName = "SFDisplay-Text Medium"
            textLabel.font = UIFont(name: fontName, size: newSize)
            //textLabel.textColor = GlobalVariables.purple
            headerView.tintColor = UIColor.white
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        print("OK editing complete...")
        if let indexPath = getIndexPathRelativeToUIView(textField){
            //update budget entity
            //print("category is \(budgetCategory)")
            if budgetCategory != "Goals"{
                let budgetEntity = budgetSectionContent[indexPath.section][indexPath.row] as! BudgetModel
                if let amount = textField.text{
                    if let double = Double(amount){
                        textField.text = String(format: "%.2f", double)
                        budgetEntity.amount = double
                        BudgetManager.persistContext()
                        collectTotals()
                        if budgetEntity.frequency == nil {
                            let cell = dataTableView.cellForRow(at: indexPath) as! BudgetTableViewCell
                            cell.frequencyOptionField.backgroundColor = GlobalVariables.pinkRed
                        }
                    }else{
                        budgetEntity.amount = 0
                        budgetEntity.frequency = nil
                        let cell = dataTableView.cellForRow(at: indexPath) as! BudgetTableViewCell
                        cell.frequencyOptionField.setTitle("Frequency", for: .normal)
                        cell.frequencyOptionField.backgroundColor = GlobalVariables.purple
                        BudgetManager.persistContext()
                        collectTotals()
                    }
                }
                
            } else {
                let goalEntity = budgetSectionContent[indexPath.section][indexPath.row] as! SavingGoalsModel
                if let goalAmount = textField.text{
                    if let double = Double(goalAmount){
                        //print("SWEET \(double)")
                        textField.text = String(format: "%.2f", double)
                        goalEntity.amount = double
                        SavingGoalsManager.persistContext()
                        collectTotals()
                    }else{
                        //print("HOLY FUCK \(textField.text)")
                    }
                }
                
            }
        }
    }
    
    func hasIncompleteFields() -> Bool{
        return false
    }
    
    func hasIncompleteData(_ items: [BudgetModel]) -> Bool{
        for item in items{
            if item.amount > 0{
                if item.frequency == nil{
                    return true
                }
            }
        }
        return false
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if hasIncompleteFields(){
            return false
        }
        return true
    }
    
    @IBAction func changeFrequency(_ sender: UIButton) {
        view.endEditing(true)
        let indexPath = getIndexPathRelativeToUIView(sender)
        let budgetEntity = budgetSectionContent[(indexPath?.section)!][(indexPath?.row)!] as! BudgetModel
        
        //Client request - Would it be possible to return the frequency drop downs during the setup? And only add the pop up screen for users select quarterly, half yearly or yearly?
        
        let frequencyMenu = UIAlertController(title: "Select frequency", message: nil, preferredStyle: .actionSheet)
        let options = ["Weekly", "Fortnightly", "Monthly", "Quarterly", "Half-yearly", "Yearly"]
        for option in options{
            let actionHandler = {
                (action: UIAlertAction) -> Void in
                sender.setTitle(option, for: .normal)
                //update field and object
                budgetEntity.frequency = option
                BudgetManager.persistContext()
                if ["Weekly", "Fortnightly", "Monthly"].index(of: option) != nil{
                    sender.backgroundColor = GlobalVariables.pastelGreen
                    self.collectTotals()
                }else{
                    let popupController = UIStoryboard(name: "Setup", bundle : Bundle.main).instantiateViewController(withIdentifier: "BaseBudgetPopoverViewController") as! BaseBudgetPopoverViewController
                    popupController.modalPresentationStyle = UIModalPresentationStyle.popover
                    popupController.budgetCategory = self.budgetCategory
                    popupController.selectedBudgetEntity = budgetEntity
                    popupController.isNew = false
                    self.present(popupController, animated: true)
                }
            }
            frequencyMenu.addAction(UIAlertAction(title: option, style: .default, handler: actionHandler))
        }
        /*frequencyMenu.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction) -> Void in
            BudgetManager.deleteBudgetEntity(budgetEntity: budgetEntity)
            self.reloadData()
            self.dataTableView.reloadData()
        }))*/
        frequencyMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(frequencyMenu, animated: true, completion: nil)
        
    }
    
    
    @IBAction func addField(_ sender: UIButton) {
        if budgetCategory == "Goals"{
            return
        }
        let popupController = UIStoryboard(name: "Setup", bundle: Bundle.main).instantiateViewController(withIdentifier: "BaseBudgetPopoverViewController") as! BaseBudgetPopoverViewController
        popupController.modalPresentationStyle = UIModalPresentationStyle.popover
        popupController.budgetCategory = budgetCategory
        popupController.isNew = true
        self.present(popupController, animated: true)
    }
    
    @IBAction func goalCreateAction(_ sender: UIButton) {
        if budgetCategory != "Goals"{
            return
        }
        let popupController = UIStoryboard(name: "Setup", bundle: Bundle.main).instantiateViewController(withIdentifier: "SavingGoalsPopupViewController") as! SavingGoalsPopupViewController
        popupController.modalPresentationStyle = UIModalPresentationStyle.popover
        popupController.isNew = true
        self.present(popupController, animated: true)
    }
    
    @IBAction func goalChangeAction(_ sender: UIButton) {
        let indexPath = getIndexPathRelativeToUIView(sender)
        let goalEntity = budgetSectionContent[(indexPath?.section)!][(indexPath?.row)!] as! SavingGoalsModel
        let popupController = UIStoryboard(name: "Setup", bundle: Bundle.main).instantiateViewController(withIdentifier: "SavingGoalsPopupViewController") as! SavingGoalsPopupViewController
        popupController.modalPresentationStyle = UIModalPresentationStyle.popover
        popupController.goalEntity = goalEntity
        popupController.isNew = false
        self.present(popupController, animated: true)
    }
    
}
